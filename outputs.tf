data "template_file" "ngw_ips" {
  template = "$${az_a},$${az_c},$${az_d}"
  vars {
    az_a = "${aws_eip.eip-ngw-a.public_ip}"
    az_c = "${aws_eip.eip-ngw-c.public_ip}"
    az_d = "${aws_eip.eip-ngw-d.public_ip}"
  }
}

output "nat_gateway_ip" {
  value = "${data.template_file.ngw_ips.rendered}"
}
