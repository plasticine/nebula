if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
fi

source /etc/network-environment

export NOMAD_ADDR="http://$DEFAULT_IPV4:4646"
export CONSUL_HTTP_ADDR="$DEFAULT_IPV4:8500"
export CONSUL_RPC_ADDR="$DEFAULT_IPV4:8400"
