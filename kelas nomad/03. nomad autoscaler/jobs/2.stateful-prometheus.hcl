job "2.stateful-prometheus" {
  type        = "service"
  datacenters = ["jkt-1"]

  update {
    max_parallel = 0
  }

  group "prometheus" {

    volume "prometheus-volume" {
      type      = "host"
      source    = "prometheus" // from client
      read_only = false
    }

    network {
      mode = "bridge"
      port "prometheus_ui" {
        static = 9090
        to     = 9090
      }
    }

    task "prometheus" {
      driver = "docker"

      config {
        image              = "prom/prometheus:v2.45.5"
        ports              = ["prometheus_ui"]
        image_pull_timeout = "10m"

        args = [
          "--storage.tsdb.retention.size=1GB",
          "--storage.tsdb.retention.time=1w",
          "--config.file=/etc/prometheus/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles"
        ]

        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml",
        ]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      volume_mount {
        volume      = "prometheus-volume"
        destination = "/prometheus"
        read_only   = false
      }

      service {
        provider = "nomad"
        name     = "prometheus"
        port     = "prometheus_ui"

        check {
          type     = "http"
          path     = "/-/healthy"
          interval = "2s"
          timeout  = "3s"
        }
      }

      template {
        data = <<EOF
global:
    scrape_interval: 3s
    scrape_timeout: 2s

scrape_configs:
    - job_name: nomad
      metrics_path: /v1/metrics
      params:
        format: ['prometheus']
      static_configs:
        - targets:
          {{- range nomadService "svc-dummy-nomad-client-addr" }}
          - {{ .Address }}:4646
          {{- end }}
EOF

        destination = "local/prometheus.yml"
        change_mode = "restart"
        // change_signal = "SIGHUP"
      }
    }
  }
}