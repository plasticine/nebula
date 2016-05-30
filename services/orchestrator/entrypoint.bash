#!/usr/bin/env bash

set -e

PID="-1"

term_handler() {
  echo "[orchanstrator] received SIGTERM - stopping!"
  kill -s SIGTERM $PID
  wait $pid
  exit 143; # 128 + 15 -- SIGTERM
}

main() {
  local command="$@"

  echo "[orchanstrator] running '$command'"
  mix $command &
  PID=$!
  echo "[orchanstrator] started with pid:$PID"
  wait $PID
}

trap term_handler SIGTERM
main "$@"
