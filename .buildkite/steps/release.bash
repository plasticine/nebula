#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

export RELEASE_BUILD_TAG="$(echo $BUILDKITE_COMMIT | head -c 8)"
export NOMAD_VERSION="$NOMAD_VERSION"
export MIX_ENV="$MIX_ENV"

main() {
  echo '--- :elixir: Building app service...'
  pushd "services/nebula" > /dev/null
  script/build
  script/release
  popd > /dev/null

  echo '--- :nginx: Building web service release...'
  pushd "services/web" > /dev/null
  script/build
  popd > /dev/null
}

main
