packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

##### AWS - ubuntu-focal
source "amazon-ebs" "ubuntu-focal" {
  ami_name      = "belajar-packer-aws"
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
  ssh_username = "ubuntu"
}

build {
  name = "setup-nginx"
  sources = [
    "source.amazon-ebs.ubuntu-focal",
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

  // post-processors
  post-processors {

    post-processor "manifest" {
      output = "packer-manifest.json"
    }

    post-processor "shell-local" {
      inline = [
        "echo 'Process complete, Image ID is:'",
        "jq -r '.builds[0].artifact_id' packer-manifest.json | cut -d ':' -f 2",
      ]

    }
  }
}


