data "template_file" "ngw_ips" {
  template = "$${az_a},$${az_c}"
  vars {
    az_a = "${aws_eip.eip-ngw-a.public_ip}"
    az_c = "${aws_eip.eip-ngw-c.public_ip}"
  }
}

output "nat_gateway_ip" {
  value = "${data.template_file.ngw_ips.rendered}"
}
