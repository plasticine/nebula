variable "server_count" {
  type = "string"
  default = "3"
}

variable "ami" {
  type = "string"
}

variable "server_instance_type" {
  type = "string"
  default = "t2.nano"
}

variable "vpc_id" {
  type = "string"
}

variable "bastion_host" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "security_groups" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "private_key_path" {
 type = "string"
}

variable "region" {
  type = "string"
}

variable "provisioning_bucket_id" {
  type = "string"
}
