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
}

##### AWS - ubuntu-focal
source "amazon-ebs" "ubuntu-focal" {
  ami_name      = "belajar-packer-aws-ubuntu-focal-${local.current_timestamp}"
  instance_type = "t3.micro"
  access_key    = "AWS_ACCESS_KEY"
  secret_key    = "AWS_SECRET_KEY"
  region        = "ap-southeast-3"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = local.aws_ssh_user
}

##### AWS - ubuntu-jammy
source "amazon-ebs" "ubuntu-jammy" {
  ami_name      = "belajar-packer-aws-ubuntu-jammy-${local.current_timestamp}"
  instance_type = "t3.micro"
  access_key    = "AWS_ACCESS_KEY"
  secret_key    = "AWS_SECRET_KEY"
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
  name = "setup-nginx"
  sources = [
    "source.amazon-ebs.ubuntu-focal",
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
}


