job "nebula" {
    type = "service"
    datacenters = ["dc1"]

    update {
        stagger = "30s"
        max_parallel = 1
    }

    task_group "nebula" {
        count = "3"

        task "web" {
            driver = "docker"

            config {
                image = "gcr.io/nebula-1338/nebula/web:11832c69"
                port_map {
                    http = 80
                    https = 443
                }
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
                    port "https" {}
                }
            }
        }

        task "app" {
            driver = "docker"

            config {
                image = "gcr.io/nebula-1338/nebula/app:fa1ae37b"
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
                    port "https" {}
                }
            }
        }
    }
}
