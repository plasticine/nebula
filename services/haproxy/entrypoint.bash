#!/usr/bin/env bash

set -e

pid="0"

log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

term_handler() {
  log "received SIGTERM - stopping!"
  kill -SIGTERM $(cat /run/haproxy.pid)
  wait $pid
  exit 143; # 128 + 15 -- SIGTERM
}

main() {
  local pidfile;
  local haproxy_start;
  local haproxy_check;
  local config;

  pidfile="/run/haproxy.pid"
  config="/container/haproxy/conf/haproxy.cfg"
  haproxy_check="haproxy -f ${config} -c"
  haproxy_start="haproxy -f ${config} -D -p ${pidfile}"

  log "starting haproxy"

  $haproxy_check
  $haproxy_start

  while inotifywait -q -e create,delete,modify,attrib "${config}"; do
    if [ -f $pidfile ]; then
      log "Restarting HAProxy due to config changes..."
      $haproxy_check
      $haproxy_start -sf $(cat $pidfile)
      log "HAProxy restarted, pid $(cat $pidfile)." && log
    else
      log "Error: no $pidfile present, HAProxy exited."
      break
    fi
  done
}

trap term_handler SIGTERM
main "$@"
