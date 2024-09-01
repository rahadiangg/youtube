job "3.nomad-autoscaler" {
  type        = "service"
  datacenters = ["jkt-1"]

  group "nomad-autoscaler" {
    count = 3

    network {
      mode = "bridge"
      port "http" {
        // dynamic port
      }
    }

    task "nomad-autoscaler" {
      driver = "docker"

      config {
        image = "hashicorp/nomad-autoscaler:0.4.5"
        args = [
          "agent",
          "-config=${NOMAD_TASK_DIR}/autoscaler-config.hcl",
          "-http-bind-address=0.0.0.0",
          "-http-bind-port=${NOMAD_PORT_http}"
        ]

        volumes = [
          "local/nomad-autoscaler-policies.hcl:/opt/nomad-autoscaler/policies/nomad-autoscaler-policies.hcl"
        ]
      }

      resources {
        cpu    = 50
        memory = 64
      }

      service {
        name     = "nomad-autoscaler"
        provider = "nomad"
        port     = "http"

        check {
          type     = "http"
          path     = "/v1/health"
          interval = "5s"
          timeout  = "2s"
        }
      }

      template {
        destination   = "local/autoscaler-config.hcl"
        change_mode   = "signal"
        change_signal = "SIGHUP"
        data          = <<EOF
log_level = "INFO"

nomad {
  address = "http://{{ env "attr.unique.network.ip-address" }}:4646"
  token = "20016077-d82b-67e3-71db-507369e885cb"
  namespace = "default"
}

high_availability {
  enabled        = true
  lock_namespace = "default"
  lock_path      = "nomad-autoscaler/lock"
  lock_ttl       = "30s"
  lock_delay     = "15s"
}

apm "prometheus-mantap" {
  driver = "prometheus"

  config = {
    {{- range nomadService "prometheus" }}
    address = "http://{{ .Address }}:{{ .Port }}"
    {{- end }}
  }
}

strategy "target-value-mantap" {
  driver = "target-value"
}

target "nomad-mantap" {
  driver = "nomad-target"
}

target "aws-asg-mantap" {
  driver = "aws-asg"
  config = {
    
    aws_region            = "ap-southeast-3"
    aws_access_key_id     = "ABCDEFG"
    aws_secret_access_key = "1234567"
  }
}

policy {
  dir = "/opt/nomad-autoscaler/policies"
  default_cooldown = "30s"
  default_evaluation_interval = "10s"
}
EOF
      }

      template {
        destination = "local/nomad-autoscaler-policies.hcl"
        change_mode = "noop"
        data        = <<EOF
      scaling "to_aws_asg_jakarta" {
        enabled = false
        min = 0
        max = 3

        policy {
          cooldown = "1m"
          evaluation_interval = "10s"

          check "allocated_cpu" {
            source = "prometheus-mantap"
            query = "100-sum(nomad_client_unallocated_cpu{})/sum(nomad_client_allocated_cpu{}+nomad_client_unallocated_cpu{})*100"

            strategy "target-value-mantap" {
              target = 55
            }
          }

          target "aws-asg-mantap" {
            aws_asg_name = "nomad-client-asg"
            node_drain_deadline = "3m"
            node_purge = true
            node_pool = "default"
          }
        }
      }
      EOF
      }

    }
  }
}