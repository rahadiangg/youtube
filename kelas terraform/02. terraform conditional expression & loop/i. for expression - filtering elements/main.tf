terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

// pull image
resource "docker_image" "nginx_alpine" {
  name         = "nginx:alpine"
  keep_locally = true
}

variable "env_config" {
  type = list(object({
    key        = string
    value      = string
    is_enabled = bool
  }))


  default = [{
    key        = "SECRET_KEY"
    value      = "aaabbcc"
    is_enabled = true
    }, {
    key        = "order_svc_host"
    value      = "blabla.order.local"
    is_enabled = false
  }]
}

// run container
resource "docker_container" "nginx" {
  count = 3
  image = docker_image.nginx_alpine.image_id

  name = "nginx-${count.index}"
  ports {
    external = 8080 + count.index
    internal = 80
  }

  // implementasi for expression
  // untuk "is_enabled" di object env_config akan kita bahas materi berikutnya

  // ini akan berupa tupple
  env = [for e in var.env_config : "${upper(e.key)}=${e.value}" if e.is_enabled == true]
}

output "list_env_created" {
  // ini akan berupa object
  value       = { for e in var.env_config : upper(e.key) => e.value if e.is_enabled}
  description = "env yang dibuat"
}

output "list_ip_container" {
  // ini akan berupa tupple
  value       = [for con in docker_container.nginx : one(con.network_data).ip_address]
  description = "semua alamat IP container yang dibuat"
}