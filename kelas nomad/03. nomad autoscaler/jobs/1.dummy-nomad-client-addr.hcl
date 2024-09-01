job "1.dummy-nomad-client-addr" {

  type = "system"

  group "dummy-group" {

    network {
      port "dummy-port" {
      }
    }

    task "dummmy-task" {

      driver = "exec"
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "tail -f /dev/null"
        ]
      }

      resources {
        cpu    = 10
        memory = 20
      }

      service {
        provider = "nomad"
        name     = "svc-dummy-nomad-client-addr"
        port     = "dummy-port"
      }
    }
  }
}