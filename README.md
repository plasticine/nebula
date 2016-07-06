# Nebula

:warning: **Just hacking, don't expect to find anything useful here...** :warning:

***

### Install development toolchain

- `brew update && brew install vagrant nomad consul`

### Generate a development certificate

- `openssl genrsa -out /etc/ssl/dummy.key 2048`
- `openssl req -new -key /etc/ssl/dummy.key -out /etc/ssl/dummy.csr -subj "/C=GB/L=London/O=Company Ltd/CN=haproxy"`
- `openssl x509 -req -days 3650 -in /etc/ssl/dummy.csr -signkey /etc/ssl/dummy.key -out /etc/ssl/dummy.crt`

### Vagrant node services

- http://172.20.10.10:8500/ui/#/dc1/services
- http://172.20.10.10:4646/v1/nodes

### Useful commands

- `vagrant ssh -c "sudo journalctl -f -u nomad -u consul"`


#### Useful reading

- https://cloud.google.com/solutions/automated-build-images-with-jenkins-kubernetes
- http://code.hootsuite.com/build-test-and-automate-server-image-creation/
- http://web.archive.org/web/20150910104010/https://www.airpair.com/aws/posts/ntiered-aws-docker-terraform-guide
- https://www.iocaine.org/posts/experimenting-with-terraform-consul-and-amazon-ec2.html
- http://blog.cloudcoreo.com/consul-production-ready-with-cloudcoreo/
- https://blog.nimbusscale.com/2015/12/28/leveraging-consuls-dns-interface/
- https://5pi.de/2015/04/27/cloudformation-driven-consul-in-autoscalinggroup/
- http://www.paulstack.co.uk/blog/2015/12/30/autoscaling-group-notifications-with-terraform-and-aws-lambda
- https://github.com/hashicorp/terraform/issues/1552#issuecomment-190864512
