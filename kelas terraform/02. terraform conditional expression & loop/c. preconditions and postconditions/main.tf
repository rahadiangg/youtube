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

variable "allow_expose_port" {
  type    = bool
  default = false
}

// run container
resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id
  name  = var.container_name
  ports {
    external = 8080
    internal = 80
  }

  // biasanya docker secara default mempunyai network yang namanya "bridge"
  network_mode = data.docker_network.default_bridge.name

  lifecycle {
    // precondition & postcondition dapat di definisikan lebih dari 1x

    precondition {
      condition     = !contains(split(":", docker_image.nginx_alpine.name), "latest")
      error_message = "jangan gunakan image dengan tag latest"
    }

    // pada postcondition kita dapat menggunakan spesial object "self"
    // yang dimana untuk merefer ke argument dirinya sendiri
    postcondition {
      condition     = length(self.ports) > 0
      error_message = "tentukan minimal satu port yang terexpose"
    }

    postcondition {
      condition     = !(var.allow_expose_port == false)
      error_message = "tidak diizinkan untik mengexpose port"
    }
  }
}


// ambil informasi docker network
data "docker_network" "default_bridge" {
  name = "bridge"
  lifecycle {
    postcondition {
      condition     = self.driver == "bridge"
      error_message = "driver docker network harus \"bridge\""
    }
  }
}

output "subnet_network" {
  value = one(data.docker_network.default_bridge.ipam_config).subnet

  // berdasarkan dokumentasi lifecycle dapat digunakan
  // tapi penulis coba di versi 1.5.2 tidak dapat digunakan
  // mungkin update terbaru lifecycle di output sudah dihilangkan

  # lifecycle {
  #   precondition {
  #     condition     = parseint(split("/", one(data.docker_network.default_bridge.ipam_config).subnet)[1], 100) < 16
  #     error_message = "pastikan gunakan subnet lebih dari /16"
  #   }
  # }
}