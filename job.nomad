job "nebula" {
    type = "service"
    datacenters = ["dc1"]

    meta {
        DEPLOYMENT_ID = ""
    }

    update {
        stagger = "10s"
        max_parallel = 1
    }

    task "web" {
        driver = "docker"
        config {
            image = "gcr.io/nebula-1338/nebula/web:${NOMAD_META_DEPLOYMENT_ID}"
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
            cpu = 128
            memory = 128
            network {
                mbits = 1
                port "http" {}
                port "https" {}
            }
        }
    }

    task "app" {
        driver = "docker"
        config {
            image = "gcr.io/nebula-1338/nebula/app:${NOMAD_META_DEPLOYMENT_ID}"
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
            cpu = 128
            memory = 128
            network {
                mbits = 1
                port "http" {}
                port "https" {}
            }
        }
    }
}
