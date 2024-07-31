job "b.expose-service" {

  type = "system"

  group "nginx-exposer-group" {

    network {
      mode = "host"
      port "http-nginx" {
        static = 80 # make sure static port
        to     = 80
      }
    }

    task "nginx-exposer" {
      driver = "docker"

      config {
        network_mode = "host"
        image        = "nginx:1.27-bookworm"
        volumes = [
          "local/nginx-config.conf:/etc/nginx/conf.d/default.conf"
        ]
      }

      resources {
        cpu    = 20
        memory = 20
      }

      template {
        destination   = "local/nginx-config.conf"
        change_mode   = "restart"
        data          = <<EOF
upstream dashboard-app {
    {{- range nomadService "service-dashboard-app" }}
    server  {{ .Address }}:{{ .Port }};
    {{- end }}
}

server {
    listen       {{ env "NOMAD_PORT_http_nginx" }};
    server_name  dashboard.mantapdjiwa.com;

    access_log /dev/stdout;
    error_log /dev/stderr;

    location / {
        proxy_pass http://dashboard-app;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF
      }
    }
  }
}