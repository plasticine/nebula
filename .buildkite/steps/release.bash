#!/usr/bin/env bash
#
# Build and package a release.

set -euo pipefail
IFS=$'\n\t'

readonly RELEASE_BUILD_VERSION="$(echo $BUILDKITE_COMMIT | head -c 8)"
readonly REGISTRY_URL="${REGISTRY_ADDRESS}/${GCP_PROJECT_NAME}"

main() {
  pushd "services/nebula" > /dev/null
  echo '--- :elixir: :docker: Building app image...'
  script/build "nebula/app:${RELEASE_BUILD_VERSION}"

  echo '--- :elixir: :truck: Making release artifact for app...'
  script/release
  popd > /dev/null

  pushd "services/web" > /dev/null
  echo '--- :nginx: :docker: Building web image...'
  script/build "nebula/web:${RELEASE_BUILD_VERSION}"
  popd > /dev/null

  echo '--- :crystal_ball: :docker: Pushing built images...'
  docker tag "nebula/web:${RELEASE_BUILD_VERSION}" "${REGISTRY_URL}/nebula/web:${RELEASE_BUILD_VERSION}"
  docker tag "nebula/app:${RELEASE_BUILD_VERSION}" "${REGISTRY_URL}/nebula/app:${RELEASE_BUILD_VERSION}"
  docker push "${REGISTRY_URL}/nebula/web:${RELEASE_BUILD_VERSION}"
  docker push "${REGISTRY_URL}/nebula/app:${RELEASE_BUILD_VERSION}"
}

main
