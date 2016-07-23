resource "template_file" "nomad-startup-script" {
  lifecycle { create_before_destroy = true }
  template = "${file("${path.module}/resources/nomad-server-startup-script.bash.template")}"

  vars {
    nomad_bootstrap_expect = "${var.nomad_bootstrap_expect}"
  }
}

resource "template_file" "nomad-shutdown-script" {
  lifecycle { create_before_destroy = true }
  template = "${file("${path.module}/resources/nomad-server-shutdown-script.bash.template")}"
}

resource "google_compute_http_health_check" "nomad-cluster-health-check" {
  name = "nomad-cluster-health-check"
  request_path = "/v1/status/peers"
  port = 4646
}

resource "google_compute_instance_template" "nomad-cluster-template" {
  lifecycle { create_before_destroy = true }

  name_prefix = "nomad-cluster-template-"
  machine_type = "f1-micro"
  can_ip_forward = true

  metadata = {
    startup-script = "${template_file.nomad-startup-script.rendered}"
    shutdown-script = "${template_file.nomad-shutdown-script.rendered}"
  }

  tags = ["nomad-server", "nomad", "no-ip"]

  disk {
    source_image = "${var.nomad_image_name}"
    auto_delete = true
    boot = true
  }

  network_interface {
    network = "default"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "nomad-cluster-pool" {
  name = "nomad-cluster-pool"

  health_checks = [
    "${google_compute_http_health_check.nomad-cluster-health-check.name}",
  ]
}

# TODO add health checking here
resource "google_compute_instance_group_manager" "nomad-cluster-group-manager" {
  name = "nomad-cluster-group-manager"
  zone = "us-central1-a"

  instance_template  = "${google_compute_instance_template.nomad-cluster-template.self_link}"
  target_pools       = ["${google_compute_target_pool.nomad-cluster-pool.self_link}"]
  base_instance_name = "nomad"
}

resource "google_compute_autoscaler" "nomad-cluster-autoscaler" {
  name   = "nomad-cluster-autoscaler"
  zone   = "us-central1-a"
  target = "${google_compute_instance_group_manager.nomad-cluster-group-manager.self_link}"

  autoscaling_policy = {
    min_replicas    = "${var.nomad_bootstrap_expect}"
    max_replicas    = "1"
    cooldown_period = "240"

    cpu_utilization {
      target = "0.8"
    }
  }
}
