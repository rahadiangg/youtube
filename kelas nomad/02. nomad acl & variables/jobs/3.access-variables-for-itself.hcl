job "access-variables-for-itself" {

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

      template {
        env         = false
        destination = "local/config-app"
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/access-variables-for-itself/dummy-group/dummy-task" }}
{{- range $key, $value := . }}
{{ $key }}={{ $value }}
{{- end }}
{{- end }}
EOF
      }
    }
  }
}