#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

readonly RELEASE_BUILD_TAG="$(echo $BUILDKITE_COMMIT | head -c 8)"

build_app_image() {
  docker build \
    --build-arg NOMAD_VERSION=${NOMAD_VERSION} \
    --build-arg MIX_ENV={$MIX_ENV} \
    --tag "nabula_app_${RELEASE_BUILD_TAG}:latest" \
    services/nebula
}

build_web_image() {
  docker build \
    --tag "nabula_web_${RELEASE_BUILD_TAG}:latest" \
    services/web
}

main() {
  build_nebula_image
  build_web_image
}

main
