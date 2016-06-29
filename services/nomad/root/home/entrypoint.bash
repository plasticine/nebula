#!/usr/bin/env bash

set -e

service docker start
/usr/local/bin/nomad $@
