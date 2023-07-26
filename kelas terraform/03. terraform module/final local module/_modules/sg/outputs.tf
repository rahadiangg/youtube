output "security_group_names" {
  value = [ aws_security_group.sg_nginx.name ]
  description = "Ini adalah list name dari security"
}