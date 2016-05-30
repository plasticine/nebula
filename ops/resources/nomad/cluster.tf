resource "null_resource" "nomad-cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join(",", aws_instance.server.*.id)}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    user = "ubuntu"
    host = "${element(aws_instance.server.*.private_ip, 0)}"
    private_key = "${file(var.private_key_path)}"
    bastion_host = "${var.bastion_host}"
    timeout = "5m"
  }

  provisioner "remote-exec" {
    inline = [
    "/usr/local/bin/nomad-join ${join(" ", formatlist("%s:4646", aws_instance.server.*.private_ip))}"
    ]
  }
}
