job "2.double-task-one-grup" {

  group "double-task-group" {

    task "test-exec-satu" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c", "echo 'Task 1 is running'; sleep 3600"
        ]
      }

      resources {
        cpu = 100 # MHz
        // cores = 1 # Core
        memory = 100 # MB

        # should enable first
        # https://developer.hashicorp.com/nomad/tutorials/advanced-scheduling/memory-oversubscription
        // memory_max = 200 #MB
      }
    }

    task "test-exec-kedua" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c", "echo 'Task 2 is running'; sleep 3600"
        ]
      }

      resources {
        cpu = 100 # MHz
        // cores = 1 # Core
        memory = 100 # MB

        # should enable first
        # https://developer.hashicorp.com/nomad/tutorials/advanced-scheduling/memory-oversubscription
        // memory_max = 200 #MB
      }
    }
  }
}