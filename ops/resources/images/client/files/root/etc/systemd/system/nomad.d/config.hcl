data_dir  = "/var/lib/nomad"
log_level = "INFO"
disable_anonymous_signature = true
disable_update_check = true

addresses {
    rpc  = "ADVERTISE_ADDR"
    http = "ADVERTISE_ADDR"
}

advertise {
    http = "ADVERTISE_ADDR:4646"
    rpc  = "ADVERTISE_ADDR:4647"
}

client {
    enabled = true
    options {
        "driver.raw_exec.enable" = "1"
        "driver.exec.enable" = "1"
        "driver.docker.enable" = "1"
    }
}
