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
  gcloud compute copy-files "${DEPLOY_MACHINE_NAME}" --quiet job.nomad deploy/job.nomad
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --quiet --command="ls -al"
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --quiet --command="cat deploy/job.nomad"
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --quiet --command="nomad status"
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --quiet --command="nomad run deploy/job.nomad"
}

main
