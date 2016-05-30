#!/usr/bin/env bash

set -e

PID="-1"

term_handler() {
  echo "[git] received SIGTERM - stopping!"
  kill -s SIGTERM $PID
  exit 143; # 128 + 15 -- SIGTERM
}

main() {
  echo "[git] starting..."
  /usr/bin/spawn-fcgi -p 6000 /usr/sbin/fcgiwrap && nginx -c /etc/nginx/nginx.conf -g "daemon off;" &
  PID=$!
  echo "[git] started with pid:$PID"
  wait $PID
}

trap term_handler SIGTERM
main
