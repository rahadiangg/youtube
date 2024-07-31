bind_addr = "0.0.0.0"
data_dir  = "/opt/nomad/data"

region     = "indonesia"
datacenter = "jkt-2"

name = "client-2" // default to hostname

client {
  enabled = true
  servers = ["172.31.4.0"] // change to your Nomad server IP
}

ui {
  enabled = true
}