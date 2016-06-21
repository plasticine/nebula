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
