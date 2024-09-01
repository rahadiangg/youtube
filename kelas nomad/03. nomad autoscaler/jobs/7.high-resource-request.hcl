job "7.high-resource-request.hcl" {

  datacenters = [
    "jkt-1"
  ]

  group "high-group" {
    count = 5

    task "high-task" {
      driver = "exec"
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "tail -f /dev/null"
        ]
      }

      resources {
        cores  = 1
        memory = 20
      }
    }
  }
}