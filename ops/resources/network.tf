resource "google_compute_route" "instance-egress" {
  name = "instance-egress"
  dest_range = "0.0.0.0/0"
  network = "default"
  next_hop_instance = "${google_compute_instance.bastion.name}"
  next_hop_instance_zone = "${google_compute_instance.bastion.zone}"
  tags = ["internal"]
  priority = 800
}
