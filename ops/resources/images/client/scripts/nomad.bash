#!/usr/bin/env bash

set -euo pipefail
IFS=' '

readonly NOMAD_VERSION=0.4.0

# Copy essential files into place
sudo cp -R /tmp/provision/root/* /

# Install Nomad
sudo adduser --disabled-password --gecos '' nomad
sudo mkdir /var/nomad
sudo chown nomad:nomad /var/nomad

sudo mkdir -p /opt/nomad
sudo mkdir -p /opt/nomad/data

curl -o /tmp/nomad.zip -L https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
sudo unzip -d /usr/local/bin /tmp/nomad.zip
sudo chmod +x /usr/local/bin/nomad

# Install Nomad service
sudo chown root:root /etc/systemd/system/nomad.service
sudo chmod 0644 /etc/systemd/system/nomad.service
sudo systemctl daemon-reload

# Restart logging
sudo service rsyslog restart

# Install nomad-join and nomad-servers
sudo chmod +x /usr/local/bin/nomad-join
sudo chmod +x /usr/local/bin/nomad-servers

# Install dnsmasq
sudo apt-get install -y dnsmasq
sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq
