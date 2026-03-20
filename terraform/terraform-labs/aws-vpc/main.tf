################################################################################
# AWS VPC Infrastructure Configuration
################################################################################
# This Terraform configuration sets up a complete VPC infrastructure in AWS
# including:
# - A Virtual Private Cloud (VPC) with CIDR block 10.0.0.0/16
# - An Internet Gateway for external connectivity
# - A public subnet (10.0.1.0/24) for resources that need internet access
# - A route table with internet routing rules
# - A security group allowing all inbound and outbound traffic
#
# This setup is suitable for basic lab/testing environments and allows
# EC2 instances deployed in the public subnet to communicate with the internet.
################################################################################

# Configure AWS provider with region
provider "aws" {
  region = "us-east-1"
}

# Create a Virtual Private Cloud with DNS support
resource "aws_vpc" "vpc-terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  # enable_dns_support = true  # Uncomment to enable DNS resolution
  tags = {
    Name = "vpc-terraform"
  }
}

# Create Internet Gateway to allow VPC to communicate with the internet
resource "aws_internet_gateway" "igw-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id
  tags = {
    Name = "igw-terraform"
  }
}

# Create a public subnet within the VPC
resource "aws_subnet" "public-subnet-terraform" {
  vpc_id     = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet-terraform"
  }
}

# Create a route table for public subnet traffic
resource "aws_route_table" "public-rt-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id
  # Default route to Internet Gateway for all outbound traffic
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terraform.id
  }
  tags = {
    Name    = "public-rt-terraform"
    service = "terraform-labs"
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "public-rt-association-terraform" {
  subnet_id      = aws_subnet.public-subnet-terraform.id
  route_table_id = aws_route_table.public-rt-terraform.id
}

# Create security group to control inbound and outbound traffic
resource "aws_security_group" "allow_all_traffic" {
  name        = "allow_all_traffic"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.vpc-terraform.id

  # Allow all inbound traffic from any source
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic to any destination
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_all_traffic"
  }
}
