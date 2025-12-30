# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Create an S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = var.bucket_acl

  tags = {
    Name        = "ExampleBucket"
    Environment = "Dev"
  }
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
