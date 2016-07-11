module "consul" {
  source = "./consul"

  consul_image_name = "${var.base_image_name}"
}
