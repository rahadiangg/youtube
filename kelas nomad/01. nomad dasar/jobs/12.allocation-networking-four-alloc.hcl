job "12.allocation-networking-four-alloc" {

  type = "service"

  region = "indonesia"

  group "hello-world-group" {

    count = 4

    network {
      port "app-port" { // just define blank port stanza for dynamic port
      }
    }

    task "hello-world-app" {
      driver = "exec"

      // driver configuration
      config {
        command = "go-hello-world_${attr.kernel.name}_${attr.cpu.arch}" # this app run on port 3000
      }

      // use template stanza to render configuration and use it as env
      template {
        env         = true
        destination = "${NOMAD_SECRETS_DIR}/.env"
        data        = <<EOH
PORT={{ env "NOMAD_PORT_app_port" }}
EOH
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