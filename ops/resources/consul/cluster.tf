# resource "null_resource" "consul-cluster" {
#   # Changes to any instance of the cluster requires re-provisioning
#   triggers {
#     cluster_instance_ids = "${join(",", aws_instance.server.*.id)}"
#   }

#   # Bootstrap script can run on any instance of the cluster
#   # So we just choose the first in this case
#   connection {
#     user = "ubuntu"
#     host = "${element(aws_instance.server.*.private_ip, 0)}"
#     private_key = "${file(var.private_key_path)}"
#     bastion_host = "${var.bastion_host}"
#     timeout = "10m"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "/usr/local/bin/consul-join ${join(" ", aws_instance.server.*.private_ip)}"
#     ]
#   }
# }
