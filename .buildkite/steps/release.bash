#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

readonly RELEASE_BUILD_VERSION="$(echo $BUILDKITE_COMMIT | head -c 8)"

export NOMAD_VERSION="$NOMAD_VERSION"
export MIX_ENV="$MIX_ENV"

main() {
  pushd "services/nebula" > /dev/null
  echo '--- :elixir: :docker: Building app image...'
  script/build "nabula_app:${RELEASE_BUILD_VERSION}"

  echo '--- :elixir: :truck: Making release artifact for app...'
  script/release
  popd > /dev/null

  pushd "services/web" > /dev/null
  echo '--- :nginx: :docker: Building web image...'
  script/build "nabula_web:${RELEASE_BUILD_VERSION}"
  popd > /dev/null

  echo '--- :crystal_ball: :docker: Pushing built images...'
  docker tag "nabula_web:${RELEASE_BUILD_VERSION}" "${REGISTRY_PATH}/nabula_web:${RELEASE_BUILD_VERSION}"
  docker tag "nabula_app:${RELEASE_BUILD_VERSION}" "${REGISTRY_PATH}/nabula_app:${RELEASE_BUILD_VERSION}"
  docker push "${REGISTRY_PATH}/nabula_web:${RELEASE_BUILD_VERSION}"
  docker push "${REGISTRY_PATH}/nabula_app:${RELEASE_BUILD_VERSION}"
}

main
