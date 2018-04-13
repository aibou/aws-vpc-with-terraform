resource "aws_elasticache_subnet_group" "public" {
  name = "${data.template_file.vpc-name.rendered}-public-subnet-group"
  description = "${data.template_file.vpc-name.rendered}-public-subnet-group"
  subnet_ids = ["${aws_subnet.subnet-pub-a.id}","${aws_subnet.subnet-pub-c.id}","${aws_subnet.subnet-pub-d.id}"]
}

resource "aws_elasticache_subnet_group" "private" {
  name = "${data.template_file.vpc-name.rendered}-private-subnet-group"
  description = "${data.template_file.vpc-name.rendered}-private-subnet-group"
  subnet_ids = ["${aws_subnet.subnet-pri-a.id}","${aws_subnet.subnet-pri-c.id}","${aws_subnet.subnet-pri-d.id}"]
}

