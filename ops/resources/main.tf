resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_key_pair" "default" {
  key_name = "infrastructure_hacking"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_s3_bucket" "provisioning" {
  bucket = "infrastructure-provisioning.pixelbloom.com"
  acl = "private"
  force_destroy = true

  tags = {
    Name = "provisioning"
  }
}
