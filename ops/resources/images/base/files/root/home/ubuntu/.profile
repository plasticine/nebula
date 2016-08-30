if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

export DEFAULT_IPV4="$(curl --silent -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)"

if [ -d "$HOME/.profile_config" ]; then
  for f in "$HOME/.profile_config/*.bash"; do source $f; done
fi
