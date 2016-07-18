resource "template_file" "nomad-server" {
  lifecycle { create_before_destroy = true }

  template = "${file("${path.module}/resources/user_data.bash.template")}"

  vars {
    nomad_bootstrap_expect = "${var.nomad_bootstrap_expect}"
  }
}

resource "google_compute_http_health_check" "nomad-server-cluster-health-check" {
  lifecycle { create_before_destroy = true }

  name = "nomad-server-cluster-health-check"
  request_path = "/"
  port = 4646
}

resource "google_compute_instance_template" "nomad-server-cluster-template" {
  lifecycle { create_before_destroy = true }

  name_prefix = "nomad-server-cluster-template-"
  machine_type = "f1-micro"
  can_ip_forward = true

  metadata = {
    startup-script = "${template_file.nomad-server.rendered}"
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

resource "google_compute_target_pool" "nomad-server-cluster-pool" {
  name = "nomad-server-cluster-pool"

  health_checks = [
    "${google_compute_http_health_check.nomad-server-cluster-health-check.name}",
  ]
}

# TODO add health checking here
resource "google_compute_instance_group_manager" "nomad-server-cluster-group-manager" {
  name = "nomad-server-cluster-group-manager"
  zone = "us-central1-a"

  instance_template  = "${google_compute_instance_template.nomad-server-cluster-template.self_link}"
  target_pools       = ["${google_compute_target_pool.nomad-server-cluster-pool.self_link}"]
  base_instance_name = "nomad-server"
}

resource "google_compute_autoscaler" "nomad-server-cluster-autoscaler" {
  name   = "nomad-server-cluster-autoscaler"
  zone   = "us-central1-a"
  target = "${google_compute_instance_group_manager.nomad-server-cluster-group-manager.self_link}"

  autoscaling_policy = {
    max_replicas    = "5"
    min_replicas    = "${var.nomad_bootstrap_expect}"
    cooldown_period = "60"

    cpu_utilization {
      target = "0.75"
    }
  }
}
