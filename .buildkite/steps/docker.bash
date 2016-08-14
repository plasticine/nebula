#!/usr/bin/env bash
#
# Build services.

set -eo pipefail

readonly NOMAD_VERSION=0.4.0
readonly MIX_ENV=prod



# docker build \
#   --build-arg NOMAD_VERSION=${NOMAD_VERSION} \
#   --build-arg MIX_ENV={$MIX_ENV} \
#   services/nebula



docker run \
  trenpixster/elixir:1.3.2

# docker build services/web
