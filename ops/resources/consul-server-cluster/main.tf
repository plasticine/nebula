resource "template_file" "consul-server-startup-script" {
  lifecycle { create_before_destroy = true }
  template = "${file("${path.module}/resources/consul-server-startup-script.bash.template")}"

  vars {
    consul_bootstrap_expect = "${var.consul_bootstrap_expect}"
  }
}

resource "template_file" "consul-server-shutdown-script" {
  lifecycle { create_before_destroy = true }
  template = "${file("${path.module}/resources/consul-server-shutdown-script.bash.template")}"
}

resource "google_compute_http_health_check" "consul-cluster-health-check" {
  name = "consul-cluster-health-check"
  request_path = "/v1/status/peers"
  port = 8500
}

resource "google_compute_instance_template" "consul-cluster-template" {
  lifecycle { create_before_destroy = true }

  name_prefix = "consul-cluster-template-"
  machine_type = "f1-micro"
  can_ip_forward = true

  metadata = {
    startup-script = "${template_file.consul-server-startup-script.rendered}"
    shutdown-script = "${template_file.consul-server-shutdown-script.rendered}"
  }

  tags = ["consul-server", "consul", "no-ip"]

  disk {
    source_image = "${var.consul_image_name}"
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

resource "google_compute_target_pool" "consul-cluster-pool" {
  name = "consul-cluster-pool"

  health_checks = [
    "${google_compute_http_health_check.consul-cluster-health-check.name}",
  ]
}

# TODO add health checking here
resource "google_compute_instance_group_manager" "consul-cluster-group-manager" {
  name = "consul-cluster-group-manager"
  zone = "us-central1-a"

  instance_template  = "${google_compute_instance_template.consul-cluster-template.self_link}"
  target_pools       = ["${google_compute_target_pool.consul-cluster-pool.self_link}"]
  base_instance_name = "consul-server"
}

resource "google_compute_autoscaler" "consul-cluster-autoscaler" {
  name   = "consul-cluster-autoscaler"
  zone   = "us-central1-a"
  target = "${google_compute_instance_group_manager.consul-cluster-group-manager.self_link}"

  autoscaling_policy = {
    min_replicas    = "${var.consul_bootstrap_expect}"
    max_replicas    = "1"
    cooldown_period = "240"

    cpu_utilization {
      target = "0.75"
    }
  }
}
