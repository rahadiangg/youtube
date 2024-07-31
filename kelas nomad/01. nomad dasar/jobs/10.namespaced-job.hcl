job "10.namespaced-job" {

  type = "service"

  namespace = "observability"

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
          "touch ${NOMAD_ALLOC_DIR}/output-from-task-1.txt"
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
          "while true; do echo \"run on node ${node.unique.name} inside ${node.datacenter} datacenter (${attr.cpu.arch}) - $(date)\" >> ${NOMAD_ALLOC_DIR}/output-from-task-1.txt; sleep 1; done"
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
          "tail -f ${NOMAD_ALLOC_DIR}/output-from-task-1.txt"
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