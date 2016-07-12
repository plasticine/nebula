#!/usr/bin/env bash

set -euo pipefail
IFS=' '

# https://cloud.google.com/compute/docs/networking#natgateway
# https://docs.tenable.com/pvs/clouddeployment/Content/GoogleCloudInstructionsNatGateway.htm
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward > /dev/null
echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding > /dev/null
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get install -y iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
