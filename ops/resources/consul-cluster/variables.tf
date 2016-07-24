variable "depend_on_bastion" { type = "string" }

variable "consul_image_name" {
  type = "string"
}

variable "consul_bootstrap_expect" {
  type = "string"
  default = "3"
}
