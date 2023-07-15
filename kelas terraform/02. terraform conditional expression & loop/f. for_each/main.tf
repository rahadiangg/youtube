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

variable "list_container" {
  type    = list(string)
  default = ["banana", "jeruk", "durian", "durian"]
}

resource "docker_container" "list_nginx" {
  // karena yang di expect adalah tipe data "map" atau "set", jadi kita convert "list" ke salah satu tipe data itu
  // disini kita convert ke tipe data "set"
  for_each = toset(var.list_container)
  image    = docker_image.nginx_alpine.image_id

  name = "nginx-list-${each.value}" // dapetin value dari looping
  ports {
    // cari index keberapa dari sebuah key
    external = 8080 + index(var.list_container, each.key)
    internal = 80
  }
}


variable "map_container" {
  type = map(object({
    name          = string
    external_port = number
  }))

  default = {
    "con_1" = { name = "mendoan", external_port = 8888 },
    "con_2" = { name = "bakwan", external_port = 9999 },
  }
}

resource "docker_container" "map_nginx" {
  for_each = var.map_container
  image    = docker_image.nginx_alpine.image_id

  name = "nginx-map-${each.key}-${each.value.name}"
  ports {
    external = each.value.external_port
    internal = 80
  }

  depends_on = [docker_container.list_nginx]
}
