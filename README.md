# Nebula

### Install development toolchain

- `brew update && brew install vagrant nomad consul`

### Generate a development certificate

- `openssl genrsa -out /etc/ssl/dummy.key 2048`
- `openssl req -new -key /etc/ssl/dummy.key -out /etc/ssl/dummy.csr -subj "/C=GB/L=London/O=Company Ltd/CN=haproxy"`
- `openssl x509 -req -days 3650 -in /etc/ssl/dummy.csr -signkey /etc/ssl/dummy.key -out /etc/ssl/dummy.crt`
