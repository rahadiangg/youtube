job "6.load-test" {

  type        = "batch"
  datacenters = ["jkt-1"]

  group "load-test" {

    count = 1

    task "vegeta" {
      driver = "exec"

      config {
        command = "vegeta"
        args = [
          "attack",
          "-duration=3m",
          "-targets=${NOMAD_TASK_DIR}/targets.txt"
        ]
      }

      artifact {
        source = "https://github.com/tsenart/vegeta/releases/download/v12.12.0/vegeta_12.12.0_${attr.kernel.name}_${attr.cpu.arch}.tar.gz"
      }

      resources {
        cpu    = 200 # MHz
        memory = 200 # MB
      }


      // use Address from svc-dummy-nomad-client-addr
      // then use port from nginx-expose
      template {
        destination = "local/targets.txt"
        change_mode = "noop"
        data        = <<EOF
{{- range nomadService "svc-dummy-nomad-client-addr" }}
GET http://{{ .Address }}:80
{{- end }}
EOF
      }
    }
  }
}