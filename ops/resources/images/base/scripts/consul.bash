#!/usr/bin/env bash

set -euo pipefail
IFS=' '

readonly CONSUL_VERSION=0.6.4

sudo adduser --disabled-password --gecos '' consul
sudo mkdir /var/consul
sudo chown consul:consul /var/consul

sudo mkdir -p /opt/consul
sudo mkdir -p /opt/consul/data

cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -O consul.zip
unzip consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul

wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip -O consul_ui.zip
sudo unzip consul_ui.zip -d /opt/consul/ui >/dev/null

# Install service
sudo mkdir -p /etc/systemd/system/consul.d
sudo mv /tmp/provision/config.json /etc/systemd/system/consul.d/config.json
sudo chown root:root /tmp/provision/consul.service
sudo mv /tmp/provision/consul.service /etc/systemd/system/consul.service
sudo chmod 0644 /etc/systemd/system/consul.service
sudo systemctl daemon-reload

# Setup logging
sudo mv /tmp/provision/consul.rsyslog /etc/rsyslog.d/10-consul.conf
sudo mv /tmp/provision/consul.logrotate /etc/logrotate.d/consul
sudo service rsyslog restart

# Install consul-join
sudo mv /tmp/provision/consul-join-cluster /usr/local/bin/consul-join-cluster
sudo chmod +x /usr/local/bin/consul-join-cluster
