variable "aws_access_key" {
  type    = string
  default = "AAABBBCCC"
}

variable "aws_secret_key" {
  type    = string
  default = "aaabbbbcccc"
}

// ==== VPC ====
variable "vpc_id" {
  type    = string
  default = "vpc-1234567890" // ID VPC
}