#!/usr/bin/env bash

set -euo pipefail
IFS=' '

# Copy essential files into place
sudo cp -R /tmp/provision/root/* /

# Install setup-network-environment binary & service
sudo mkdir -p /opt/bin
sudo wget -N -P /opt/bin https://github.com/kelseyhightower/setup-network-environment/releases/download/1.0.1/setup-network-environment
sudo chmod +x /opt/bin/setup-network-environment
sudo chown root:root /etc/systemd/system/setup-network-environment.service
sudo chmod 0644 /etc/systemd/system/setup-network-environment.service
sudo systemctl daemon-reload

# Install docker
sudo apt-get install -y linux-image-extra-$(uname -r)
sudo curl -sSL https://get.docker.com | sh
sudo usermod -aG docker ubuntu
sudo service docker start

# Install docker-compose
sudo curl -o /usr/local/bin/docker-compose -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-Linux-x86_64
sudo chmod +x /usr/local/bin/docker-compose

# Install docker-gc
sudo curl -o /etc/cron.hourly/docker-gc -L https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc
sudo chmod +x /etc/cron.hourly/docker-gc

# Setup docker logging
sudo service rsyslog restart
