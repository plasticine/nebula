#!/usr/bin/env bash

set -euo pipefail
IFS=' '

readonly NOMAD_VERSION=0.3.2

sudo adduser --disabled-password --gecos '' nomad
sudo mkdir /var/nomad
sudo chown nomad:nomad /var/nomad

cd /tmp
wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -O nomad.zip
unzip nomad.zip >/dev/null
chmod +x nomad
sudo mv nomad /usr/local/bin/nomad

sudo mkdir -p /opt/nomad/
sudo mkdir -p /opt/nomad/data

# Install nomad-join
sudo mv /tmp/provision/nomad-join /usr/local/bin/nomad-join
sudo chmod +x /usr/local/bin/nomad-join

# Install service
sudo mkdir -p /etc/systemd/system/nomad.d
sudo chown root:root /tmp/provision/nomad.service
sudo mv /tmp/provision/nomad.service /etc/systemd/system/nomad.service
sudo chmod 0644 /etc/systemd/system/nomad.service
sudo systemctl daemon-reload

# Setup logging
sudo mv /tmp/provision/nomad.rsyslog /etc/rsyslog.d/10-nomad.conf
sudo mv /tmp/provision/nomad.logrotate /etc/logrotate.d/nomad
sudo service rsyslog restart
