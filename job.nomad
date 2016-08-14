job "nebula" {
    type = "service"
    datacenters = ["dc1"]

    update {
        stagger = "10s"
        max_parallel = 1
    }

    task "web" {
        driver = "docker"
        config {
            image = "nebula/web"
            port_map {
                http = 80
                https = 443
            }
        }
        service {
            port = "http"
            tags = ["http"]
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
                mbits = 1
                port "http" {}
                port "https" {}
            }
        }
    }

    task "nebula" {
        count = 3
        driver = "docker"
        config {
            image = "nebula/nebula"
            port_map {
                http = 80
                https = 443
            }
        }
        service {
            port = "http"
            tags = ["http"]
            check {
                type = "http"
                path = "/"
                interval = "10s"
                timeout = "2s"
            }
        }
        resources {
            cpu = 512
            memory = 512
            network {
                mbits = 1
                port "http" {}
                port "https" {}
            }
        }
    }
}
