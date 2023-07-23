output "security_groups_names" {
  value = [ aws_security_group.sg_nginx.name ]
  description = "list dari name security_groups"
}


