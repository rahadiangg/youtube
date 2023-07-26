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
  default = ["jeruk", "nanas", "bengkoang"]
}

// ==== VPC ====
variable "vpc_id" {
  type    = string
  default = "vpc-aaabbbcccdddd" // ID VPC
}