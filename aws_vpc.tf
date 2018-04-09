data "template_file" "vpc-name" {
  template = "vpc-$${env}-$${pj}"
  vars {
    env = "${var.environment}"
    pj = "${var.project_name}"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name = "${data.template_file.vpc-name.rendered}"
  }
}

resource "aws_subnet" "subnet-pub-a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, 0)}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-${data.template_file.vpc-name.rendered}-public-a"
  }
}

resource "aws_subnet" "subnet-pub-c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, 1)}"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-${data.template_file.vpc-name.rendered}-public-c"
  }
}

resource "aws_subnet" "subnet-pub-d" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, 2)}"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-${data.template_file.vpc-name.rendered}-public-d"
  }
}

resource "aws_subnet" "subnet-pri-a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, 4)}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet-${data.template_file.vpc-name.rendered}-private-a"
  }
}

resource "aws_subnet" "subnet-pri-c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, 5)}"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet-${data.template_file.vpc-name.rendered}-private-c"
  }
}

resource "aws_subnet" "subnet-pri-d" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", 4, 6)}"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet-${data.template_file.vpc-name.rendered}-private-d"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw-${data.template_file.vpc-name.rendered}"
  }
}

resource "aws_route_table" "rtbl-pub" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "rtbl-${data.template_file.vpc-name.rendered}-pub"
  }
}

resource "aws_route_table_association" "rtbl-asc-pub-a" {
  subnet_id      = "${aws_subnet.subnet-pub-a.id}"
  route_table_id = "${aws_route_table.rtbl-pub.id}"
}

resource "aws_route_table_association" "rtbl-asc-pub-c" {
  subnet_id      = "${aws_subnet.subnet-pub-c.id}"
  route_table_id = "${aws_route_table.rtbl-pub.id}"
}

resource "aws_route_table_association" "rtbl-asc-pub-d" {
  subnet_id      = "${aws_subnet.subnet-pub-d.id}"
  route_table_id = "${aws_route_table.rtbl-pub.id}"
}

resource "aws_route_table" "rtbl-pri-a" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw-a.id}"
  }

  tags {
    Name = "rtbl-${data.template_file.vpc-name.rendered}-pri-a"
  }
}

resource "aws_route_table" "rtbl-pri-c" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw-c.id}"
  }

  tags {
    Name = "rtbl-${data.template_file.vpc-name.rendered}-pri-c"
  }
}

resource "aws_route_table" "rtbl-pri-d" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw-d.id}"
  }

  tags {
    Name = "rtbl-${data.template_file.vpc-name.rendered}-pri-d"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_route_table_association" "rtbl-asc-pri-a" {
  subnet_id      = "${aws_subnet.subnet-pri-a.id}"
  route_table_id = "${aws_route_table.rtbl-pri-a.id}"
}

resource "aws_route_table_association" "rtbl-asc-pri-c" {
  subnet_id      = "${aws_subnet.subnet-pri-c.id}"
  route_table_id = "${aws_route_table.rtbl-pri-c.id}"
}

resource "aws_route_table_association" "rtbl-asc-pri-d" {
  subnet_id      = "${aws_subnet.subnet-pri-d.id}"
  route_table_id = "${aws_route_table.rtbl-pri-d.id}"
}

resource "aws_vpc_endpoint_route_table_association" "ve-pri-a" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.rtbl-pri-a.id}"
}

resource "aws_vpc_endpoint_route_table_association" "ve-pri-c" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.rtbl-pri-c.id}"
}

resource "aws_vpc_endpoint_route_table_association" "ve-pri-d" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.rtbl-pri-d.id}"
}

resource "aws_eip" "eip-ngw-a" {
  vpc = true
}

resource "aws_eip" "eip-ngw-c" {
  vpc = true
}

resource "aws_eip" "eip-ngw-d" {
  vpc = true
}

resource "aws_nat_gateway" "ngw-a" {
  allocation_id = "${aws_eip.eip-ngw-a.id}"
  subnet_id     = "${aws_subnet.subnet-pub-a.id}"
}

resource "aws_nat_gateway" "ngw-c" {
  allocation_id = "${aws_eip.eip-ngw-c.id}"
  subnet_id     = "${aws_subnet.subnet-pub-c.id}"
}

resource "aws_nat_gateway" "ngw-d" {
  allocation_id = "${aws_eip.eip-ngw-d.id}"
  subnet_id     = "${aws_subnet.subnet-pub-d.id}"
}
