output "server_public_ips" {
  value = "${join(",", aws_instance.server.*.private_ip)}"
}
