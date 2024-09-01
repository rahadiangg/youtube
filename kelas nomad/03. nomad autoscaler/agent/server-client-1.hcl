bind_addr = "0.0.0.0"
data_dir  = "/opt/nomad/data"

region     = "indonesia"
datacenter = "jkt-1"

name = "server-client-1" // default to hostname

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  servers = ["127.0.0.1"]

  host_volume "prometheus" {
    path      = "/opt/prometheus"
    read_only = false
  }
}

ui {
  enabled = true
}

acl {
  enabled = true
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  disable_hostname           = true
  prometheus_metrics         = true
}