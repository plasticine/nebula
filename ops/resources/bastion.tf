# ##
# # Create a bastion host to allow SSH in to the test network.
# # Connections are only allowed from ${var.allowed_network}
# # This box also acts as a NAT for the private network
# ##
# resource "aws_security_group" "bastion" {
#   name = "bastion"
#   description = "Allow access from allowed_network to SSH/Consul, and NAT internal traffic"
#   vpc_id = "${aws_vpc.infrastructure_hacking.id}"

#   # SSH
#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = [ "${var.allowed_network}" ]
#     self = false
#   }

#   # Consul
#   ingress {
#     from_port = 8500
#     to_port = 8500
#     protocol = "tcp"
#     cidr_blocks = [ "${var.allowed_network}" ]
#     self = false
#   }

#   # NAT
#   ingress {
#     from_port = 0
#     to_port = 65535
#     protocol = "tcp"
#     cidr_blocks = [
#       "${aws_subnet.public.cidr_block}",
#       "${aws_subnet.private.cidr_block}"
#     ]
#     self = false
#   }
# }

# resource "aws_security_group" "allow_bastion" {
#   name = "allow_bastion_ssh"
#   description = "Allow access from bastion host"
#   vpc_id = "${aws_vpc.infrastructure_hacking.id}"

#   ingress {
#     from_port = 0
#     to_port = 65535
#     protocol = "tcp"
#     security_groups = ["${aws_security_group.bastion.id}"]
#     self = false
#   }
# }

# resource "aws_instance" "bastion" {
#   ami = "ami-817454e2"  # 14.04 LTS amd64 hvm:ebs-ssd
#   instance_type = "t2.micro"
#   key_name = "${aws_key_pair.default.key_name}"
#   security_groups = ["${aws_security_group.bastion.id}"]
#   subnet_id = "${aws_subnet.dmz.id}"
#   associate_public_ip_address = true
#   source_dest_check = false
#   user_data = "${file(\"files/bastion/cloud-init.txt\")}"

#   tags = {
#     Name = "Bastion"
#     role = "bastion"
#   }
# }

# output "bastion" {
#   value = "${aws_instance.bastion.public_ip}"
# }
