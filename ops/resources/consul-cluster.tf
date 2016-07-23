module "consul-cluster" {
  source = "./consul-cluster"

  depend_on_bastion = "${google_compute_instance.bastion.self_link}"

  # Actual vars here...
  consul_image_name = "${var.node_image_name}"
  consul_bootstrap_expect = "1"
}
