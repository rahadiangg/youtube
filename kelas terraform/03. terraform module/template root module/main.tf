
// ===== EC2 =====

resource "aws_instance" "ec2" {
  count         = length(var.list_vm)
  ami           = "ami-0913922d1289852b6" // Image ID
  instance_type = "t3.micro"
  user_data     = <<EOT
#!/bin/bash
sudo apt update && sudo apt install nginx -y
sudo echo "<h1>Belajar terraform module</h1>" > /var/www/html/index.html
  EOT

  security_groups = [aws_security_group.sg_nginx.name]

  tags = {
    Name = var.list_vm[count.index]
  }
}

resource "aws_eip" "ec2_eip" {
  count    = length(var.list_vm)
  instance = aws_instance.ec2[count.index].id
}

// ===== SG =====

resource "aws_security_group" "sg_nginx" {
  name   = "allow_nginx"
  vpc_id = var.vpc_id

  ingress {
    description = "allow http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}