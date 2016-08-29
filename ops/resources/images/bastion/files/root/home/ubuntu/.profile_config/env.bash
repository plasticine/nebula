nomad_server_ip="$(nomad-servers | head -n 1)"
consul_server_ip="$(consul-servers | head -n 1)"

export NOMAD_ADDR="http://$nomad_server_ip:4646"
export CONSUL_HTTP_ADDR="$consul_server_ip:8500"
export CONSUL_RPC_ADDR="$consul_server_ip:8400"
