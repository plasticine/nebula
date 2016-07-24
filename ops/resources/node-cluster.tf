module "node-cluster" {
  source = "./node-cluster"

  depend_on_bastion = "${google_compute_instance.bastion.self_link}"

  # Actual vars here...
  nomad_image_name = "${var.node_image_name}"
  nomad_bootstrap_expect = "1"
}
