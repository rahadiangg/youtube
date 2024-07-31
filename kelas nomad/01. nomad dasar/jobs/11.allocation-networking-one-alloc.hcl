job "11.allocation-networking-one-alloc" {

  type = "service"

  region = "indonesia"

  group "hello-world-group" {

    count = 1

    network {
      port "app-port" {
      }
    }

    task "hello-world-app" {
      driver = "exec"

      // driver configuration
      config {
        command = "go-hello-world_${attr.kernel.name}_${attr.cpu.arch}" # this app run on port 3000
      }

      // get application binary
      // https://developer.hashicorp.com/nomad/docs/job-specification/artifact
      artifact {
        source = "https://github.com/rahadiangg/go-hello-world/releases/download/v0.0.1/go-hello-world_${attr.kernel.name}_${attr.cpu.arch}"
      }

      resources {
        cpu = 100 # MHz
        // cores = 1 # Core
        memory = 100 # MB

      }
    }
  }
}