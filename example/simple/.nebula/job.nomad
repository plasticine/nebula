job "simple-example" {
    type = "service"
    datacenters = ["dc1"]

    update {
        stagger = "30s"
        max_parallel = 1
    }

    group "web" {
        count = 1

        task "frontend" {
            driver = "docker"
            config {
                image = "nginx:1.10.0-alpine"
                port_map {
                    http = 80
                    https = 443
                }
            }
            service {
                port = "http"
                check {
                    type = "http"
                    path = "/"
                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                cpu = 256
                memory = 128
                network {
                    mbits = 100
                    port "http" {}
                    port "https" {}
                }
            }
        }
    }
}
