nomad: .dev/bin/nomad agent -dev -data-dir=data/nomad -bind=$HOST_IP -log-level=DEBUG -config=.dev/nomad/config.hcl
consul: .dev/bin/consul agent -dev -client=0.0.0.0 -bootstrap -ui-dir=.dev/consul/ui -data-dir=data/consul -advertise=$HOST_IP
