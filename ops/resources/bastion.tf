resource "google_compute_instance" "bastion" {
  name           = "bastion"
  machine_type   = "f1-micro"
  zone           = "us-central1-a"
  can_ip_forward = true

  tags = ["bastion", "nat"]

  metadata_startup_script = "echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward && sudo iptables -t nat -A POSTROUTING -j MASQUERADE"

  disk {
    image = "${var.bastion_image_name}"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  # metadata {
  #   sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  # }
}
