job "4.go-hello-world" {

  type        = "service"
  datacenters = ["jkt-1"]

  group "hello-world-group" {

    count = 2

    scaling {
      enabled = true
      min     = 2
      max     = 10

      policy {
        evaluation_interval = "3s"
        cooldown            = "5s"

        check "cpu-usage" {
          source              = "prometheus-mantap"
          query               = "sum by (task_group) (nomad_client_allocs_cpu_total_ticks{exported_job=\"4.go-hello-world\",task_group=\"hello-world-group\"})/sum by (task_group) (nomad_client_allocs_cpu_allocated{exported_job=\"4.go-hello-world\",task_group=\"hello-world-group\"})"
          query_window        = "20s"
          query_window_offset = "15s"

          strategy "target-value-mantap" {
            target = 0.8
          }

          // actualy this part not required
          target "nomad-mantap" {
            Namespace = "default"
            Job       = "4.go-hello-world"
            Group     = "hello-world-group"
          }
        }
      }
    }

    network {
      mode = "bridge"
      port "app-port" {
        to = "3000"
      }
    }

    task "hello-world-app" {
      driver = "docker"

      config {
        image             = "rahadiangg/go-hello-world:latest"
        cpu_hard_limit    = true
        memory_hard_limit = 20
        cpu_cfs_period    = 1000000 # 1 second (in microseconds)
      }


      resources {
        cpu    = 10 # MHz
        memory = 20 # MB
      }

      service {
        provider = "nomad"
        name     = "go-hello-world"
        port     = "app-port"

        check {
          type     = "http"
          method   = "GET"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
          port     = "app-port"
        }
      }
    }
  }
}