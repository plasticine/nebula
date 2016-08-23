if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
fi

export DEFAULT_IPV4="$(curl --silent -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)"
export NOMAD_ADDR="http://$DEFAULT_IPV4:4646"
export CONSUL_HTTP_ADDR="$DEFAULT_IPV4:8500"
export CONSUL_RPC_ADDR="$DEFAULT_IPV4:8400"
