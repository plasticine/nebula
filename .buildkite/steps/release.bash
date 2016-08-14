#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

readonly RELEASE_BUILD_TAG="$(echo $BUILDKITE_COMMIT | head -c 8)"

main() {
  export RELEASE_BUILD_TAG="$RELEASE_BUILD_TAG"
  export NOMAD_VERSION="$NOMAD_VERSION"
  export MIX_ENV="$MIX_ENV"

  services/nebula/script/build
  services/nebula/script/release
  services/web/script/build
}

main
