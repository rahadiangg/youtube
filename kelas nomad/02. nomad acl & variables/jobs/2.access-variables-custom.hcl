job "2.access-variables-custom" {

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
        destination = "local/aws-config-demo"
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "secret/aws/demo-account" }}
{{- range $key, $value := . }}
{{ $key }}={{ $value }}
{{- end }}
{{- end }}
EOF
      }

      template {
        env         = false
        destination = "local/aws-config-staging"
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "secret/aws/staging-account" }}
{{- range $key, $value := . }}
{{ $key }}={{ $value }}
{{- end }}
{{- end }}
EOF
      }
    }
  }
}