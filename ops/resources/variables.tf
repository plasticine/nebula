variable "private_key_path" {
  description = "Path to the private key you wish to use to provision your infrastructure."
  type = "string"
  default = "/Users/justin/Projects/plasticine/infrastructure/infra"
}

variable "public_key_path" {
  description = "Path to the public key you wish to use to provision your infrastructure."
  type = "string"
  default = "~/.ssh/infrastructure_hacking.pub"
}

variable "region" {
  description = "AWS region to host your network."
  default = "ap-southeast-2"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default = "10.128.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default = "10.128.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default = "10.128.1.0/24"
}

variable "packer-ap-southeast-2-base" {
  description = "..."
}

variable "packer-ap-southeast-2-nat" {
  description = "..."
}

variable "packer-ap-southeast-2-consul" {
  description = "..."
}

variable "packer-ap-southeast-2-nomad" {
  description = "..."
}
