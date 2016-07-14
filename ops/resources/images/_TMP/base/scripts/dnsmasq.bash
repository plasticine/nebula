#!/usr/bin/env bash

set -euo pipefail
IFS=' '

sudo apt-get install -y dnsmasq

sudo mkdir -p /etc/dnsmasq.d
sudo tee /etc/dnsmasq.d/10-consul <<EOF
server=/consul/127.0.0.1#8600
EOF

sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq
