resource "template_file" "consul-server" {
  template = "${file("${path.module}/resources/user_data.bash.template")}"
}

resource "google_compute_instance_template" "consul-cluster-instance_template" {
  name         = "consul-cluster"
  machine_type = "f1-micro"

  metadata = {
    startup-script = "${template_file.consul-server.rendered}"
  }

  tags = ["consul-server", "consul"]

  disk {
    source_image = "${var.consul_image_name}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "consul-cluster" {
  name = "consul-cluster"
}

# TODO add health checking here
resource "google_compute_instance_group_manager" "consul-cluster" {
  name = "consul-cluster"
  zone = "us-central1-a"

  instance_template  = "${google_compute_instance_template.consul-cluster.self_link}"
  target_pools       = ["${google_compute_target_pool.consul-cluster.self_link}"]
  base_instance_name = "consul-server"
}

resource "google_compute_autoscaler" "consul-server-autoscaler" {
  name   = "consul-server"
  zone   = "us-central1-a"
  target = "${google_compute_instance_group_manager.consul-cluster.self_link}"

  autoscaling_policy = {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
