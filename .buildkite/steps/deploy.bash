#!/usr/bin/env bash
#
# Deploy release.

set -euo pipefail
IFS=$'\n\t'

readonly DEPLOY_MACHINE_NAME="${DEPLOY_MACHINE_NAME}"

readonly REMOTE_COMMAND=$(cat <<EOF
export NOMAD_ADDR="http://10.128.0.4:4646"
nomad status
EOF
)

main() {
  echo '--- :rocket: Deploying...'
  gcloud config set compute/region us-central1
  gcloud config set compute/zone us-central1-a
  gcloud compute copy-files --quiet job.nomad "${DEPLOY_MACHINE_NAME}:~/job.nomad"
  gcloud compute ssh "${DEPLOY_MACHINE_NAME}" --quiet --command="${REMOTE_COMMAND}"
}

main
