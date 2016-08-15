#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

export RELEASE_BUILD_TAG="$(echo $BUILDKITE_COMMIT | head -c 8)"
export NOMAD_VERSION="$NOMAD_VERSION"
export MIX_ENV="$MIX_ENV"

main() {
  pushd "services/nebula" > /dev/null
  echo '--- :elixir: :docker: Building app image...'
  script/build

  echo '--- :elixir: :truck: Making release artifact for app...'
  script/release
  popd > /dev/null

  pushd "services/web" > /dev/null
  echo '--- :nginx: :docker: Building web image...'
  script/build
  popd > /dev/null
}

main
