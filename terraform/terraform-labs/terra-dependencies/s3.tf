# This file contains the S3 bucket resources for the Terraform dependencies lab.
# first Bucket depends on the public route table association.
# second bucket  depends on first bucket and third bucket depends on second bucket. 
# This will create a chain of dependencies between the buckets and the route table association.
resource "aws_s3_bucket" "necromonger0123456789" {
  bucket = "necromonger0123456789"

  tags = {
    Name        = "My Bucket 01"
    Environment = "Dev"
  }
  depends_on = [aws_route_table_association.public]
}


resource "aws_s3_bucket" "necromonger01234567887" {
  bucket = "necromonger01234567887"

  tags = {
    Name        = "My Bucket 02"
    Environment = "Dev"
  }
  depends_on = [aws_s3_bucket.necromonger0123456789]
}


resource "aws_s3_bucket" "necromonger012345678123" {
  bucket = "necromonger012345678123"

  tags = {
    Name        = "My Bucket 03"
    Environment = "Dev"
  }
  depends_on = [aws_s3_bucket.necromonger01234567887]
}
