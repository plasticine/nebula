#!/usr/bin/env bash

set -euo pipefail
IFS=' '

sudo apt-get install -y linux-image-extra-4.4.0-31-generic
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
