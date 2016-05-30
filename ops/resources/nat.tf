resource "aws_instance" "nat" {
  ami = "${var.packer-ap-southeast-2-nat}"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-2a"
  subnet_id = "${aws_subnet.public.id}"
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
  key_name = "${aws_key_pair.default.key_name}"
  source_dest_check = false

  tags = {
    Name = "NAT"
    role = "nat"
  }

  connection {
    user = "ubuntu"
    private_key = "${var.private_key_path}"
  }
}

output "NAT Public IP" {
  value = "${aws_instance.nat.public_ip}"
}
