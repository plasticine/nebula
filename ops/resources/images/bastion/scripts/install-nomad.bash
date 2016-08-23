#!/usr/bin/env bash

set -euo pipefail
IFS=' '

readonly NOMAD_VERSION=0.4.0

# Install Nomad
sudo mkdir -p /opt/nomad
sudo mkdir -p /opt/nomad/data
curl -o /tmp/nomad.zip -L https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
sudo unzip -d /usr/local/bin /tmp/nomad.zip
sudo chmod +x /usr/local/bin/nomad
