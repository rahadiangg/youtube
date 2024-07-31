job "9.job-sysbatch" {

  type = "sysbatch"

  region = "indonesia"

  group "install-nginx-group" {

    task "install-nginx" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "echo \"installing nginx on ${node.unique.name}....\"; sleep 10;"
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