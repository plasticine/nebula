#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

export RELEASE_BUILD_TAG="$(echo $BUILDKITE_COMMIT | head -c 8)"
export NOMAD_VERSION="$NOMAD_VERSION"
export MIX_ENV="$MIX_ENV"

main() {
  echo '+++ :elixir: Building release...'

  pushd "services/nebula" > /dev/null
  services/nebula/script/build
  services/nebula/script/release
  popd > /dev/null

  pushd "services/web" > /dev/null
  services/web/script/build
  popd > /dev/null
}

main
