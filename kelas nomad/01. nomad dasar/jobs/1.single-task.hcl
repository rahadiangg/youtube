job "1.single-task" {

  group "single-task-group" {

    task "test-exec" {
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
  }
}