packer {
  required_plugins {
    amazon = {
      version = "~> 1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  current_timestamp = formatdate("DDMMYY-hhmm", timestamp())
  aws_ssh_user      = "ubuntu"
}

variable "aws_ak" {
  type = string
}

variable "aws_sk" {
  type = string
}

variable "nomad_server_1" {
  type = string
}

variable "nomad_region" {
  type = string
}

variable "nomad_datacenter" {
  type = string
}

##### AWS - ubuntu-jammy
source "amazon-ebs" "ubuntu-jammy" {
  ami_name      = "nomad-client-ubuntu-jammy-${local.current_timestamp}"
  instance_type = "t3.medium"
  access_key    = var.aws_ak
  secret_key    = var.aws_sk
  region        = "ap-southeast-3"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = local.aws_ssh_user
}

build {
  name = "setup-nomad-client"
  sources = [
    "source.amazon-ebs.ubuntu-jammy",
  ]

  # install docker & nomad
  provisioner "shell" {
    scripts = [
      "${path.root}/scripts/install-latest-docker.sh",
      "${path.root}/scripts/setup-nomad.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo mkdir /etc/nomad.d"
    ]
  }

  # upload nomad file configuration
  provisioner "file" {
    content = templatefile("${path.root}/configs/nomad-configuration.pkrtpl.hcl", {
      nomad_server_1   = var.nomad_server_1,
      nomad_region     = var.nomad_region,
      nomad_datacenter = var.nomad_datacenter
    })
    destination = "/tmp/nomad.hcl"
  }

  # systemd service file
  provisioner "file" {
    source      = "${path.root}/configs/nomad.service"
    destination = "/tmp/nomad.service"
  }

  // # copy nomad configuration
  provisioner "shell" {
    inline = [
      "sudo cp /tmp/nomad.hcl /etc/nomad.d",
      "sudo cp /tmp/nomad.service /etc/systemd/system/nomad.service"
    ]
  }
}