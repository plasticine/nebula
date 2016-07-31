# Nebula

:warning: **Just hacking, don't expect to find anything useful here...** :warning:

***

### Install development toolchain

If you’re on a Mac then go grab [Docker for Mac](https://docs.docker.com/engine/installation/mac/).

- `brew update && brew install vagrant`

### Bootstrap

- `make vm && make up`
- `open http://nebula.dev:9999`

### Debugging API

- Install & start XQuartz
- `make up`
- `make nebula_inspect`

#### Useful stuff that I’ve found...

- https://cloud.google.com/solutions/automated-build-images-with-jenkins-kubernetes
- http://code.hootsuite.com/build-test-and-automate-server-image-creation/
- http://web.archive.org/web/20150910104010/https://www.airpair.com/aws/posts/ntiered-aws-docker-terraform-guide
- https://www.iocaine.org/posts/experimenting-with-terraform-consul-and-amazon-ec2.html
- http://blog.cloudcoreo.com/consul-production-ready-with-cloudcoreo/
- https://blog.nimbusscale.com/2015/12/28/leveraging-consuls-dns-interface/
- https://5pi.de/2015/04/27/cloudformation-driven-consul-in-autoscalinggroup/
- http://www.paulstack.co.uk/blog/2015/12/30/autoscaling-group-notifications-with-terraform-and-aws-lambda
- https://github.com/hashicorp/terraform/issues/1552#issuecomment-190864512
