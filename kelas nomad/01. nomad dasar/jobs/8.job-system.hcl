job "8.job-system" {

  type = "system"

  region = "indonesia"

  group "log-collector-group" {

    task "log-collector" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "while true; do echo \"collecting logs from ${node.unique.name}....\"; sleep 10; done"
        ]
      }

      resources {
        cpu = 100 # MHz
        // cores = 1 # Core
        memory = 100 # MB

      }
    }
  }
}