packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  current_timestamp = formatdate("DDMMYY-hhmm", timestamp())
  aws_ssh_user      = "ubuntu"
  ami_name          = data.amazon-ami.ubuntu-jammy.name
}

variable "aws_ak" {
  type      = string
  default   = "AWS_ACCESS_KEY"
  sensitive = true
}

variable "aws_sk" {
  type      = string
  default   = "AWS_SECRET_KEY"
  sensitive = true
}

data "amazon-ami" "ubuntu-jammy" {
  filters = {
    name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]

  # butuh mendefinisikan AK & SK
  access_key = var.aws_ak
  secret_key = var.aws_sk
}

##### AWS - ubuntu-jammy
source "amazon-ebs" "ubuntu-jammy" {
  ami_name      = "belajar-packer-aws-ubuntu-jammy-${local.current_timestamp}"
  instance_type = "t3.micro"
  access_key    = var.aws_ak
  secret_key    = var.aws_sk
  region        = "ap-southeast-3"
  source_ami_filter {
    filters = {
      name = local.ami_name
    }

    # For security reasons, your source AMI filter must declare an owner.
    owners = ["099720109477"]
  }
  ssh_username = local.aws_ssh_user
}

build {
  name = "setup-nginx"
  sources = [
    "source.amazon-ebs.ubuntu-jammy",
  ]

  provisioner "shell" {
    inline = [
      "echo ==== Install nginx",
      "sudo apt update",
      "sudo apt install nginx -y",
      "echo ==== Web template for AWS",
      "echo '<h1>Halo dari Packer - AWS</h1>' > index.html",
      "sudo chown root:root index.html",
      "sudo mv index.html /var/www/html/index.html",
      "sudo systemctl enable nginx"
    ]
  }

  post-processor "shell-local" {
    inline = [
      "echo 'Image name: ${local.ami_name}'"
    ]
  }
}


