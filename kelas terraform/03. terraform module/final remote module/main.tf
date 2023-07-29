
// ===== EC2 =====
module "ec2" {
  source               = "git::https://github.com/rahadiangg/terraform-belajar-module.git//ec2?ref=v1.0.0"
  aws_access_key       = var.aws_access_key
  aws_secret_key       = var.aws_secret_key
  list_vm              = var.list_vm
  security_group_names = module.sg.security_group_names
}

// ===== SG =====
module "sg" {
  source         = "git::https://github.com/rahadiangg/terraform-belajar-module.git//sg?ref=v1.0.0"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpc_id         = var.vpc_id
}

