job "7.job-batch" {

  type = "batch"

  group "rendering-group" {

    task "convert-mkv-to-mp4" {
      driver = "exec"

      // driver configuration
      config {
        command = "/bin/bash"
        args = [
          "-c",
          "echo \"rendering...\"; sleep 20; echo \"completed at $(date)\"; exit 0;"
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