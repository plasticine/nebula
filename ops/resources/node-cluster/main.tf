resource "template_file" "node-startup-script" {
  lifecycle { create_before_destroy = true }

  template = "${file("${path.module}/resources/node-startup-script.bash.template")}"

  vars {
    nomad_bootstrap_expect = "${var.nomad_bootstrap_expect}"
  }
}

resource "template_file" "node-shutdown-script" {
  lifecycle { create_before_destroy = true }
  template = "${file("${path.module}/resources/node-shutdown-script.bash.template")}"
}

resource "google_compute_http_health_check" "node-health-check" {
  name = "node-health-check"
  request_path = "/health"
  port = 9998
}

resource "google_compute_instance_template" "node-cluster-template" {
  lifecycle { create_before_destroy = true }

  name_prefix = "node-cluster-template-"
  machine_type = "n1-standard-2"
  can_ip_forward = true

  metadata = {
    startup-script = "${template_file.node-startup-script.rendered}"
    shutdown-script = "${template_file.node-shutdown-script.rendered}"
  }

  tags = ["node", "nomad", "no-ip"]

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

resource "google_compute_target_pool" "node-cluster-pool" {
  name = "node-cluster-pool"

  health_checks = [
    "${google_compute_http_health_check.node-health-check.name}"
  ]
}

resource "google_compute_instance_group_manager" "node-cluster-group-manager" {
  name = "node-cluster-group-manager"
  zone = "us-central1-a"

  instance_template  = "${google_compute_instance_template.node-cluster-template.self_link}"
  target_pools       = ["${google_compute_target_pool.node-cluster-pool.self_link}"]
  base_instance_name = "node"

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }
}

resource "google_compute_autoscaler" "node-cluster-autoscaler" {
  name   = "node-cluster-autoscaler"
  zone   = "us-central1-a"
  target = "${google_compute_instance_group_manager.node-cluster-group-manager.self_link}"

  autoscaling_policy = {
    min_replicas    = "${var.nomad_bootstrap_expect}"
    max_replicas    = "1"
    cooldown_period = "240"

    cpu_utilization {
      target = "0.75"
    }
  }
}

resource "google_compute_forwarding_rule" "node-cluster-forwarding-rule" {
  name = "node-cluster-forwarding-rule"
  target = "${google_compute_target_pool.node-cluster-pool.self_link}"
}
