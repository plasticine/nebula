variable "account_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
  default = "../config/account.json"
}

variable "project_name" {
  description = "The ID of the Google Cloud project"
}

variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-a"
}

# variable "host_domain" {
#   description = "..."
# }

variable "base_image_name" {
  description = "..."
}

variable "bastion_image_name" {
  description = "..."
}


variable "node_image_name" {
  description = "..."
}
