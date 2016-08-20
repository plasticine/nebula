#!/usr/bin/env bash
#
# Deploy release.

set -euo pipefail
IFS=$'\n\t'

readonly BASTION_ADDRESS="${BASTION_ADDRESS}"

main() {
  ssh "ubuntu@${BASTION_ADDRESS}" la -al
}

main
