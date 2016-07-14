#!/usr/bin/env bash

set -euo pipefail
IFS=' '

echo "Rebooting the machine..."
sudo reboot
sleep 60
