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

variable "exposed_ports" {
  type = list(object({
    ext = number
    int = number
  }))

  default = [{
    ext = 8080
    int = 80
    }, {
    ext = 8181
    int = 81
  }]

}

// run container
resource "docker_container" "nginx" {
  image = "nginx:alpine"

  name = "nginx-con-alpine"
  # ports {
  #   external = 8080
  #   internal = 80
  # }
  # ports {
  #   external = 8181
  #   internal = 81
  # }

  // pendefinisian ports blocks diatas dapat disingkat menggunakan dynamic blocks
  dynamic "ports" {
    for_each = toset(var.exposed_ports) // expectednya adalah map atau set

    content {
      external = ports.value.ext
      internal = ports.value.int
    }
  }
}

resource "docker_container" "apache" {
  image = "httpd:alpine"

  name = "apache-con-alpine"

  // pendefinisian ports blocks diatas dapat disingkat menggunakan dynamic blocks
  dynamic "ports" {
    for_each = toset(var.exposed_ports) // expectednya adalah map atau set

    content {
      external = ports.value.ext + 2 // biar portnya gak tabrakan
      internal = ports.value.int
    }
  }
}