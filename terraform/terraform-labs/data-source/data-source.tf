# Add manually created VPC as data source and attach it to a new Internet Gateway to allow communication with the internet. 
# This is to demonstrate how to use data sources in Terraform to reference existing infrastructure.
data "aws_vpc" "vpc-data-source" {
  id = "vpc-099bcab3d61fda905"
}

# Create Internet Gateway to allow vpc-data-source to communicate with the internet
resource "aws_internet_gateway" "data-source-igw" {
  vpc_id = data.aws_vpc.vpc-data-source.id
  tags = {
    Name = "data-source-igw"
  }
}
