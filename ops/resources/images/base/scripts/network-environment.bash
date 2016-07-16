#!/usr/bin/env bash

set -euo pipefail
IFS=' '

# Install setup-network-environment binary & service
sudo mkdir -p /opt/bin
sudo wget -N -P /opt/bin https://github.com/kelseyhightower/setup-network-environment/releases/download/1.0.1/setup-network-environment
sudo chmod +x /opt/bin/setup-network-environment
sudo chown root:root /etc/systemd/system/setup-network-environment.service
sudo chmod 0644 /etc/systemd/system/setup-network-environment.service
sudo systemctl daemon-reload
