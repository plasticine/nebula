nomad-server: nomad agent -dev -log-level=INFO -config=./dev/nomad/nomad.hcl
consul-server: consul agent -dev -log-level=INFO -bind=0.0.0.0 -ui -ui-dir /ui -data-dir /data -advertise=127.0.0.1
node: docker-compose up
