#!/usr/bin/env bash
#
# Deploy release.

set -euo pipefail
IFS=$'\n\t'

readonly DEPLOY_MACHINE_NAME="${DEPLOY_MACHINE_NAME}"

main() {
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --command="ls -al"
}

main
