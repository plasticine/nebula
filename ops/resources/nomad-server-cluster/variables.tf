variable "depend_on_bastion" { type = "string" }

variable "nomad_image_name" {
  type = "string"
}

variable "nomad_bootstrap_expect" {
  type = "string"
  default = "3"
}
