#!/usr/bin/env bash

set -e

PID="-1"

term_handler() {
  echo "[web] received SIGTERM - stopping!"
  kill -s SIGTERM $PID
  exit 143; # 128 + 15 -- SIGTERM
}

main() {
  echo "[web] starting..."
  # consul-template -consul=consul-server:8500 -config=/etc/consul-template/config.conf > /dev/stdout &
  nginx -c /etc/nginx/nginx.conf -g "daemon off;" &
  PID=$!
  echo "[web] started with pid:$PID"
  wait $PID
}

trap term_handler SIGTERM
main
