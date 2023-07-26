
resource "aws_instance" "ec2" {
  count         = length(var.list_vm)
  ami           = "ami-0913922d1289852b6" // Image ID
  instance_type = "t3.micro"
  user_data     = <<EOT
#!/bin/bash
sudo apt update && sudo apt install nginx -y
sudo echo "<h1>Belajar terraform module</h1>" > /var/www/html/index.html
  EOT

  security_groups = var.security_group_names

  tags = {
    Name = var.list_vm[count.index]
  }
}

resource "aws_eip" "ec2_eip" {
  count    = length(var.list_vm)
  instance = aws_instance.ec2[count.index].id
}
