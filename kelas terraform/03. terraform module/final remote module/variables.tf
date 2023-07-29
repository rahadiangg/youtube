variable "aws_access_key" {
  type    = string
  default = "AAAABBCCCC"
}

variable "aws_secret_key" {
  type    = string
  default = "abcdefghijkl"
}

// ==== EC2 ====
variable "list_vm" {
  type    = list(string)
  default = ["jeruk", "nanas", "bengkoang"]
}

// ==== VPC ====
variable "vpc_id" {
  type    = string
  default = "vpc-0123456789" // ID VPC
}