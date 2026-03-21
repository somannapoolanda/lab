# This file contains the EC2 instance resource definition which is  deployed by referencing state file on s3
resource "aws_instance" "web-1" {
  ami                         = "ami-0ec10929233384c7f"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "dev-mentor-keypair"
  subnet_id                   = data.aws_subnet.Terraform_Public_Subnet1-testing.id
  vpc_security_group_ids      = ["${data.aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "necromonger"
    CostCenter = "tesla"
  }
}
terraform {
  backend "s3" {
    bucket = "sachindevtest1234"
    key    = "current-state.tfstate"
    region = "us-east-1"
  }
}
