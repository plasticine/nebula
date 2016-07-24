output "http_ip" {
  value = "${google_compute_forwarding_rule.node-cluster-forwarding-rule.ip_address}"
}
