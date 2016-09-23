#!/usr/bin/env bash

set -euo pipefail
IFS=' '

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -fy
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y autoremove
sudo apt-get install -y \
  git-core \
  curl \
  wget \
  htop \
  nmon \
  httpie \
  jq \
  unzip \
  zip \
  traceroute
