job "docker-login" {
  datacenters = ["dc1"]
  type = "system"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  periodic {
    cron = "*/30 * * * * *"  # Launch every 30 minutes
    prohibit_overlap = true  # Do not allow overlapping runs.
  }

  task "docker-login" {
    driver = "exec"

    config {
      command = "docker login -e 1234@5678.com -u oauth2accesstoken -p $(gcloud auth print-access-token) https://gcr.io"
    }

    resources {
      cpu = 128
      memory = 32
    }
  }
}
