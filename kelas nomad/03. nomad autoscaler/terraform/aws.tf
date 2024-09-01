provider "aws" {
  region     = "ap-southeast-3"
  access_key = var.aws_ak
  secret_key = var.aws_sk
}

locals {
  az = ["ap-southeast-3a", "ap-southeast-3b", "ap-southeast-3c"]
}

// ==== data section
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

data "aws_ami" "nomad-ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["nomad-client-*"]
  }
}

// ==== security group
resource "aws_security_group" "nomad-sg" {
  name        = "nomad-client-sg"
  description = "nomad client security group"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    protocol    = "tcp"
    description = "SSH Public"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    description = "nomad RPC internal"
    from_port   = 4647
    to_port     = 4647
    cidr_blocks = [data.aws_vpc.existing_vpc.cidr_block]
  }

  ingress {
    protocol    = "tcp"
    description = "nomad serf WAN tcp"
    from_port   = 4648
    to_port     = 4648
    cidr_blocks = [data.aws_vpc.existing_vpc.cidr_block]
  }

  ingress {
    protocol    = "udp"
    description = "nomad serf WAN udp"
    from_port   = 4648
    to_port     = 4648
    cidr_blocks = [data.aws_vpc.existing_vpc.cidr_block]
  }

  ingress {
    protocol         = "tcp"
    description      = "nomad API"
    from_port        = 4646
    to_port          = 4646
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "allow all engress"
  }


  tags = {
    Name = "sg-nomad-client"
  }
}

// ==== SSH key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nomad" {
  key_name   = "nomad-key-pair"
  public_key = tls_private_key.this.public_key_openssh
  tags = {
    Name = "nomad-key-pair"
  }
}

// === auto scaling
resource "aws_launch_template" "nomad" {
  name = "nomad-client-launch-template"

  image_id      = data.aws_ami.nomad-ami.id
  instance_type = "t3.small"
  # vpc_security_group_ids = [aws_security_group.nomad-sg.id]

  key_name = aws_key_pair.nomad.key_name

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      delete_on_termination = true
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.nomad-sg.id]
  }

  monitoring {
    enabled = true
  }

  tags = {
    Name = "nomad-client-launch-template"
  }

  user_data = filebase64("${path.module}/run-nomad-client.sh")
}

resource "aws_autoscaling_group" "nomad" {
  name               = "nomad-client-asg"
  desired_capacity   = 0
  min_size           = 0
  max_size           = 3
  availability_zones = local.az

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.nomad.id
    version = aws_launch_template.nomad.latest_version
  }
}