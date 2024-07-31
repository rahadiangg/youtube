job "3.double-task-one-grup-shared-file" {

  group "double-task-group" {

    task "prepare-file" {

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      driver = "exec"
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "touch /alloc/data/output-from-task-1.txt"
        ]
      }
    }

    task "test-exec-satu" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "while true; do echo \"$(date)\" >> /alloc/data/output-from-task-1.txt; sleep 1; done"
        ]
      }

      resources {
        cpu = 100 # MHz
        // cores = 1 # Core
        memory = 100 # MB

      }
    }

    task "test-exec-kedua" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "tail -f /alloc/data/output-from-task-1.txt"
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