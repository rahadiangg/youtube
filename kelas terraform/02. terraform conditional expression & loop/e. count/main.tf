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

variable "container_name" {
  type    = string
  default = "nginx-container"
}

// run container
resource "docker_container" "nginx" {
  count = 3
  image = docker_image.nginx_alpine.image_id

  // karena nama mesti unik, kita dapat menkombinasikannya dengan index saat looping
  name  = "${var.container_name}-${count.index}"
  ports {
    external = 8080 + count.index
    internal = 80
  }
}