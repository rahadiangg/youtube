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
  default = "vpc-0e95ae3ac5546b1f7" // ID VPC
}