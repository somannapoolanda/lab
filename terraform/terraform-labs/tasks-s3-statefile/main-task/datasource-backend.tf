data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-0dd79f0dfecfaeb43"
}

data "aws_subnet" "Terraform_Public_Subnet1-testing" {
  id = "subnet-0a15f03e78c95c3a5"
}

data "aws_security_group" "allow_all" {
  id = "sg-0e66d9766c2d4ce72"
}
