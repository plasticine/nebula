#!/usr/bin/env bash
#
# Deploy release.

set -euo pipefail
IFS=$'\n\t'

readonly DEPLOY_MACHINE_NAME="${DEPLOY_MACHINE_NAME}"

main() {
  echo '--- :rocket: Deploying...'
  gcloud config set compute/region us-central1
  gcloud config set compute/zone us-central1-a
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --command="ls -al"
}

main
