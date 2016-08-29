job "fabio" {
  datacenters = ["dc1"]
  type = "system"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {
    task "fabio" {
      driver = "exec"

      config {
        command = "fabio-1.2-go1.6.3_linux-amd64"
      }

      artifact {
        source = "https://github.com/eBay/fabio/releases/download/v1.2/fabio-1.2-go1.6.3_linux-amd64"
      }

      resources {
        cpu = 256
        memory = 64

        network {
          mbits = 1

          port "http" {
            static = 9999
          }

          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
