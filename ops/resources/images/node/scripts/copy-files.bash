#!/usr/bin/env bash

set -euo pipefail
IFS=' '

# Copy essential files into place
sudo cp -R /tmp/provision/root/* /
sudo chmod +x /usr/local/bin/*
