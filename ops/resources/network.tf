# resource "google_compute_network" "nebula" {
#   name = "nebula"
#   ipv4_range = "${var.iprange}"
# }

# resource "google_compute_firewall" "ssh-ingress" {
#   name = "nebula-ssh"
#   network = "${google_compute_network.nebula.name}"
#   source_ranges = ["${var.external_net}"]

#   allow {
#     protocol = "tcp"
#     ports = ["22"]
#   }
# }

# resource "google_compute_firewall" "internal" {
#   name = "nebula-internal"
#   network = "${google_compute_network.nebula.name}"
#   source_tags = ["internal"]
#   source_ranges = ["${var.subnet_cidr}"]

#   allow {
#     protocol = "tcp"
#     ports = ["1-65535"]
#   }

#   allow {
#     protocol = "udp"
#     ports = ["1-65535"]
#   }
# }

# resource "google_compute_firewall" "http-ingress" {
#   name = "nebula-http-ingress"
#   network = "${google_compute_network.nebula.name}"
#   source_ranges = ["${var.external_net}"]
#   target_tags = ["http-server"]

#   allow {
#     protocol = "tcp"
#     ports = ["80"]
#   }
# }

# resource "google_compute_firewall" "https-ingress" {
#   name = "nebula-https-ingress"
#   network = "${google_compute_network.nebula.name}"
#   source_ranges = ["${var.external_net}"]
#   target_tags = ["https-server"]

#   allow {
#     protocol = "tcp"
#     ports = ["443"]
#   }
# }

resource "google_compute_route" "internal-egress" {
  name = "nebula-internal-egress"
  dest_range = "0.0.0.0/0"
  network = "default"
  next_hop_instance = "${google_compute_instance.bastion.name}"
  next_hop_instance_zone = "${google_compute_instance.bastion.zone}"
  tags = ["no-ip"]
  priority = 500
  depends_on = ["google_compute_instance.bastion"]
}
