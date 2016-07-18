resource "template_file" "nomad-client" {
  lifecycle { create_before_destroy = true }

  template = "${file("${path.module}/resources/user_data.bash.template")}"

  vars {
    nomad_bootstrap_expect = "${var.nomad_bootstrap_expect}"
  }
}

resource "google_compute_http_health_check" "nomad-client-health-check" {
  lifecycle { create_before_destroy = true }

  name = "nomad-client-health-check"
  request_path = "/"
  port = 4646
}

resource "google_compute_instance_template" "nomad-client-cluster-template" {
  lifecycle { create_before_destroy = true }

  name_prefix = "nomad-client-cluster-template-"
  machine_type = "f1-micro"
  can_ip_forward = true

  metadata = {
    startup-script = "${template_file.nomad-client.rendered}"
  }

  tags = ["nomad-client", "nomad", "no-ip"]

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

resource "google_compute_target_pool" "nomad-client-cluster-pool" {
  name = "nomad-client-cluster-pool"

  health_checks = [
    "${google_compute_http_health_check.nomad-client-health-check.name}",
  ]
}

# TODO add health checking here
resource "google_compute_instance_group_manager" "nomad-client-cluster-group-manager" {
  name = "nomad-client-cluster-group-manager"
  zone = "us-central1-a"

  instance_template  = "${google_compute_instance_template.nomad-client-cluster-template.self_link}"
  target_pools       = ["${google_compute_target_pool.nomad-client-cluster-pool.self_link}"]
  base_instance_name = "nomad-client"
}

resource "google_compute_autoscaler" "nomad-client-cluster-autoscaler" {
  name   = "nomad-client-cluster-autoscaler"
  zone   = "us-central1-a"
  target = "${google_compute_instance_group_manager.nomad-client-cluster-group-manager.self_link}"

  autoscaling_policy = {
    max_replicas    = "5"
    min_replicas    = "${var.nomad_bootstrap_expect}"
    cooldown_period = "60"

    cpu_utilization {
      target = "0.75"
    }
  }
}
