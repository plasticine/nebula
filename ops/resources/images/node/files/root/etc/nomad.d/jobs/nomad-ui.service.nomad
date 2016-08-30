job "nomad-ui" {
    type = "service"
    datacenters = ["dc1"]

    task "web" {
        driver = "docker"

        config {
            image = "iverberk/nomad-ui:0.1.0"
            port_map {
                http = 3000
            }
        }

        env {
            NOMAD_ADDR = "10.128.0.3"
        }

        service {
            port = "http"
            tags = ["urlprefix-/"]
            check {
                type = "http"
                path = "/"
                interval = "15s"
                timeout = "2s"
            }
        }

        resources {
            cpu = 128
            memory = 128
            network {
                mbits = 1
                port "http" {}
            }
        }
    }
}
