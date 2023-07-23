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