job "14.communicating-task-inside-group" {

  type = "service"
  group "demo-app-group" {

    network {
      mode = "host"
      port "dashboard-app" { # generate random port
      }

      port "product-app" { # generate random port
      }

      port "review-app" { # generate random port
      }
    }

    task "dashboard" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "rahadiangg/demo-istio:dashboard-svc-1.0.0"
        ports = [
          "dashboard-app"
        ]
      }

      resources {
        cpu    = 300
        memory = 300
      }

      ## https://developer.hashicorp.com/nomad/docs/job-specification/template
      template {
        env         = true
        destination = "${NOMAD_TASK_DIR}/.env"
        data        = <<EOH
HOSTNAME="0.0.0.0"
PORT={{ env "NOMAD_PORT_dashboard_app" }}
PRODUCT_URI=http://{{ env "NOMAD_ADDR_product_app" }}/products
REVIEW_URI=http://{{ env "NOMAD_ADDR_review_app" }}/reviews
EOH
      }
    }

    task "product" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "rahadiangg/demo-istio:product-svc-1.0.0"
        ports = [
          "product-app"
        ]
      }

      resources {
        cpu    = 100
        memory = 100
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

    task "review" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "rahadiangg/demo-istio:review-svc-3.0.0"
        ports = [
          "review-app"
        ]
      }

      resources {
        cpu    = 100
        memory = 100
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