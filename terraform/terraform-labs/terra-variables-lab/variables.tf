variable "region_name" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tag_name" {
  description = "Tag name for the VPC"
  type        = string
  default     = "MyVPC"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_az" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "subnet_tag_name" {
  description = "Tag name for the public subnet"
  type        = string
  default     = "PublicSubnet"
}

variable "igw_tag" {
  description = "Tag name for the Internet Gateway"
  type        = string
  default     = "MyIGW"
}

variable "rt_cidr" {
  description = "CIDR block for the route table to route traffic to the IGW"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rt_tag" {
  description = "Tag name for the route table"
  type        = string
  default     = "PublicRouteTable"
}

variable "ec2_az" {
  description = "Availability zone for the EC2 instance"
  type        = string
  default     = "us-east-1a"
}

variable "ec2_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the existing EC2 key pair to use for SSH access"
  type        = string
  default     = "dev-mentor-keypair"
}
