#!/usr/bin/env bash
#
# Deploy release.

set -euo pipefail
IFS=$'\n\t'

readonly DEPLOY_MACHINE_NAME="${DEPLOY_MACHINE_NAME}"

readonly REMOTE_COMMAND=$(cat <<EOF
export NOMAD_ADDR="http://$(nomad-servers | head -n 1):4646"
nomad status
nomad run ~/job.nomad
EOF
)

upload_job() {
  echo '+++ Uploading Nomad job file'
  gcloud compute copy-files --quiet job.nomad "${DEPLOY_MACHINE_NAME}:~/job.nomad"
}

run_job() {
  echo '+++ Running Nomad job'
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --quiet --command="${REMOTE_COMMAND}"
}

main() {
  echo '+++ :googlecloud: Deploying...'
  gcloud config set compute/region us-central1
  gcloud config set compute/zone us-central1-a

  upload_job
  run_job
}

main
