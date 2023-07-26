variable "aws_access_key" {
  type    = string
}

variable "aws_secret_key" {
  type    = string
}

// ==== EC2 ====
variable "list_vm" {
  type    = list(string)
}

variable "security_group_names" {
  type = list(string)
}