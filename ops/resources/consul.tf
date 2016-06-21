module "consul" {
  source = "./consul"

  consul_image_name = "${var.consul_image_name}"
}
