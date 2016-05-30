# infrastructure
Experimenting with server infrastructure

## Setting up

Install some useful system things:

```
brew update && brew install aws terraform consul packer
```

Setup an SSH key for our new system:

```
ssh-keygen -q -t rsa -f ~/.ssh/infrastructure_hacking -N '' -C infrastructure_hacking
ssh-add ~/.ssh/infrastructure_hacking
```

## Make servers come out!

```
# Preferably use aws-vault here instead...
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

# Provide a consul encryption key
export CONSUL_ENCRYPT_KEY=$(consul keygen)

# this will ensure that images are built and available, then build infrastructure using them.
aws-vault exec personal -- make
```


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
