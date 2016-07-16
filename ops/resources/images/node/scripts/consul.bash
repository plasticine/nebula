#!/usr/bin/env bash

set -euo pipefail
IFS=' '

readonly CONSUL_VERSION=0.6.4

sudo mkdir -p /opt/consul
sudo mkdir -p /opt/consul/data

# Install Consul
curl -o /tmp/consul.zip -L https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
sudo unzip /tmp/consul.zip -d /usr/local/bin
sudo chmod +x /usr/local/bin/consul

# Install Consul UI
curl -o /tmp/consul_ui.zip -L https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip
sudo unzip consul_ui.zip -d /opt/consul/ui

# Install consul service
sudo mkdir -p /etc/systemd/system/consul.d
sudo chown root:root /etc/systemd/system/consul.service
sudo chmod 0644 /etc/systemd/system/consul.service
sudo systemctl daemon-reload

# Setup logging
sudo service rsyslog restart

# Install consul tools
sudo chmod +x /usr/local/bin/consul-join
sudo chmod +x /usr/local/bin/consul-servers
