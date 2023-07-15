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

  validation {
    // cek nama contaier depannya harus "nginx-"
    // dan tidak ada spasi
    condition     = substr(var.container_name, 0, 6) == "nginx-" && !contains(regexall("[a-zA-Z0-9][a-zA-Z0-9_.-]", var.container_name), " ")
    error_message = "nama container tidak menggunakan prefix \"nginx-\" atau ada karakter space"
  }
}

// run container
resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id
  name  = var.container_name
  ports {
    external = 8080
    internal = 80
  }
}