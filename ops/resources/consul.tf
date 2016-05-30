module "consul" {
  source = "./consul"

  bastion_host = "${aws_instance.nat.public_ip}"
  key_name = "${aws_key_pair.default.key_name}"
  private_key_path = "${var.private_key_path}"
  provisioning_bucket_id = "${aws_s3_bucket.provisioning.id}"
  region = "${var.region}"
  security_groups = "${aws_security_group.default.id}"
  ami = "${var.packer-ap-southeast-2-consul}"
  server_count = "3"
  subnet_id = "${aws_subnet.private.id}"
  vpc_id = "${aws_vpc.default.id}"
  recursor = "${cidrhost(var.vpc_cidr, 2)}"
  key_name = "${aws_key_pair.default.key_name}"
}
