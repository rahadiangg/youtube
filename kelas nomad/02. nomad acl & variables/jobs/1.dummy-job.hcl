job "1.dummy-job" {

  namespace = "default"

  group "dummy-group" {

    task "dummy-task" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c", "echo 'Task 1 is running'; sleep 3600"
        ]
      }

      resources {
        cpu    = 100 # MHz
        memory = 100 # MB
      }
    }
  }
}