job "13.bridge-networing-four-alloc" {

  type = "service"

  region = "indonesia"
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "hello-world-group" {

    count = 4

    network {
      mode = "bridge"

      port "app-port" {
        to = 3000
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