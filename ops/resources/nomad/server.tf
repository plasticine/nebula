resource "template_file" "server" {
  template = "${file("${path.module}/resources/user_data.yml.template")}"

  vars {
    aws_region = "${var.region}"
    provisioning_bucket_id = "${var.provisioning_bucket_id}"
    server_count = "${var.server_count}"
  }
}

resource "aws_instance" "server" {
  ami = "${var.ami}"
  count = "${var.server_count}"
  instance_type = "${var.server_instance_type}"
  availability_zone = "ap-southeast-2a"
  subnet_id = "${var.subnet_id}"
  security_groups = ["${split(",", var.security_groups)}"]
  key_name = "${var.key_name}"
  user_data = "${template_file.server.rendered}"

  tags = {
    Name = "nomad-${count.index}"
    Group = "nomad"
    role = "nomad"
  }
}
