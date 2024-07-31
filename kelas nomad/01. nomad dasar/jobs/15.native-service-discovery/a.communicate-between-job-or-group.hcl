job "a.communicate-between-job-or-group" {

  type = "service"


  group "dashboard-group" {

    count = 2

    network {
      mode = "host"
      port "dashboard-app" { # generate random port
        to = 3000
      }
    }

    service {
      provider = "nomad"
      name     = "service-dashboard-app"
      port     = "dashboard-app"
      // address  = "${attr.unique.platform.aws.public-ipv4}"
    }

    task "dashboard-app" {
      driver = "docker"
      config {
        // network_mode = "host"
        image = "rahadiangg/demo-istio:dashboard-svc-1.0.0-node16"
        ports = [
          "dashboard-app"
        ]
      }

      resources {
        cpu    = 100
        memory = 100
      }

      ## https://developer.hashicorp.com/nomad/docs/job-specification/template
      ### https://developer.hashicorp.com/nomad/docs/job-specification/template?#simple-load-balancing-with-nomad-services
      template {
        env         = true
        destination = "${NOMAD_TASK_DIR}/.env"
        change_mode = "restart"
        data        = <<EOH
HOSTNAME="0.0.0.0"
{{- $allocID := env "NOMAD_ALLOC_ID" -}}

{{- range nomadService 1 $allocID "service-product-app" }}
PRODUCT_URI=http://{{ .Address }}:{{ .Port }}/products
{{- end }}

{{- range nomadService 1 $allocID "service-review-app" }}
REVIEW_URI=http://{{ .Address }}:{{ .Port }}/reviews
{{- end }}
EOH
      }
    }
  }

  group "product-group" {

    count = 3

    network {
      mode = "host"
      port "product-app" { # generate random port
      }
    }

    service {
      provider = "nomad"
      name     = "service-product-app"
      port     = "product-app"
      // address = "${attr.unique.platform.aws.public-ipv4}"
    }

    task "product-app" {
      driver = "docker"
      config {
        // network_mode = "host"
        image = "rahadiangg/demo-istio:product-svc-1.0.0"
        ports = [
          "product-app"
        ]
      }

      resources {
        cpu    = 20
        memory = 20
      }

      ## https://developer.hashicorp.com/nomad/docs/job-specification/template
      template {
        env         = true
        destination = "${NOMAD_TASK_DIR}/.env"
        data        = <<EOH
PORT={{ env "NOMAD_PORT_product_app" }}
EOH
      }
    }
  }

  group "review-group" {

    count = 3

    network {
      mode = "host"
      port "review-app" { # generate random port
      }
    }

    service {
      provider = "nomad"
      name     = "service-review-app"
      port     = "review-app"
      // address = "${attr.unique.platform.aws.public-ipv4}"
    }

    task "review-app" {
      driver = "docker"
      config {
        // network_mode = "host"
        image = "rahadiangg/demo-istio:review-svc-3.0.0"
        ports = [
          "review-app"
        ]
      }

      resources {
        cpu    = 20
        memory = 20
      }

      ## https://developer.hashicorp.com/nomad/docs/job-specification/template
      template {
        env         = true
        destination = "${NOMAD_TASK_DIR}/.env"
        data        = <<EOH
PORT={{ env "NOMAD_PORT_review_app" }}
EOH
      }
    }
  }
}