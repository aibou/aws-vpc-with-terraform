data "template_file" "vpc-name" {
  template = "vpc-$${env}-$${pj}"
  vars = {
    env = var.environment
    pj = var.project_name
  }
}

locals {
  availability_zone = ["a", "c", "d"]
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = data.template_file.vpc-name.rendered
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index * 2)
  availability_zone       = "${var.aws_region}${local.availability_zone[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-${data.template_file.vpc-name.rendered}-public-${local.availability_zone[count.index]}"
  }

  count = length(local.availability_zone)
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet("${var.vpc_cidr}", 4, (count.index * 2) + 1)
  availability_zone       = "${var.aws_region}${local.availability_zone[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${data.template_file.vpc-name.rendered}-private-${local.availability_zone[count.index]}"
  }

  count = length(local.availability_zone)
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${data.template_file.vpc-name.rendered}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name = "rtbl-${data.template_file.vpc-name.rendered}-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  count = length(local.availability_zone)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private[count.index].id
  }

  tags = {
    Name = "rtbl-${data.template_file.vpc-name.rendered}-private-${local.availability_zone[count.index]}"
  }

  count = length(local.availability_zone)
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
  count = length(local.availability_zone)
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private-s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private[count.index].id
  count = length(local.availability_zone)
}

resource "aws_eip" "nat-gateway" {
  vpc = true
  count = length(local.availability_zone)
}

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.nat-gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  count = length(local.availability_zone)
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "vgw.${var.vgw_prefix}.${data.template_file.vpc-name.rendered}"
  }

  count = length(var.vgw_prefix) != 0 ? 1 : 0
}
