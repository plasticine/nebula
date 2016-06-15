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

variable "account_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
}

variable "project_name" {
  description = "The ID of the Google Cloud project"
}

variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}

variable "base_image_name" {
  description = "..."
}

variable "consul_image_name" {
  description = "..."
}
