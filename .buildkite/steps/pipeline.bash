#!/usr/bin/env bash
#
# Loads the steps defined in `.buildkite/pipeline.{yml,json}` from the repo into the
# currently running Buildkite build dynamically, replacing any prior steps.

set -eo pipefail

pipeline_create() {
  cat .buildkite/pipeline.yml
}

pipeline_upload() {
  # if buildkite-agent is not directly available then spool up a docker instance
  if [ ! `which buildkite-agent` ]; then
    docker run \
      -it \
      --rm \
      -e "BUILDKITE_AGENT_ACCESS_TOKEN=${BUILDKITE_AGENT_ACCESS_TOKEN}" \
      -e "BUILDKITE_JOB_ID=${BUILDKITE_JOB_ID}" \
      -e "BUILDKITE_BUILD_ID=${BUILDKITE_BUILD_ID}" \
      -e "BUILDKITE_BUILD_NUMBER=${BUILDKITE_BUILD_NUMBER}" \
      -e "BUILDKITE_BRANCH=${BUILDKITE_BRANCH}" \
      -w "/build" \
      -v "$(pwd):/build" \
      buildkite/agent:latest pipeline upload --replace
  else
    buildkite-agent pipeline upload --replace
  fi
}

main() {
  echo ':pipeline: loading pipeline'

  pipeline_create | pipeline_upload
}

main
