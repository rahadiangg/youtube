bind_addr = "0.0.0.0"
data_dir  = "/opt/nomad/data"

region     = "${nomad_region}"
datacenter = "${nomad_datacenter}"

client {
  enabled = true
  servers = ["${nomad_server_1}"]
}

ui {
  enabled = false
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