variable "aws_access_key" {
  type    = string
}

variable "aws_secret_key" {
  type    = string
}

// ==== EC2 ====
variable "list_vm" {
  type    = list(string)
  default = ["vm1", "vm2"]
}

variable "security_groups_names" {
  type = set(string)
}