variable "aws_access_key" {
  type    = string
  default = "AAABBBCCC"
}

variable "aws_secret_key" {
  type    = string
  default = "aaabbbbcccc"
}

// ==== EC2 ====
variable "list_vm" {
  type    = list(string)
  default = ["vm1", "vm2"]
}

// ==== VPC ====
variable "vpc_id" {
  type    = string
  default = "vpc-1234567890" // ID VPC
}