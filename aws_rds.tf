resource "aws_db_subnet_group" "public" {
  name = "${data.template_file.vpc-name.rendered}-public-subnet-group"
  description = "${data.template_file.vpc-name.rendered}-public-subnet-group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "${data.template_file.vpc-name.rendered}-public-subnet-group"
  }
}

resource "aws_db_subnet_group" "private" {
  name = "${data.template_file.vpc-name.rendered}-private-subnet-group"
  description = "${data.template_file.vpc-name.rendered}-private-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${data.template_file.vpc-name.rendered}-private-subnet-group"
  }
}
