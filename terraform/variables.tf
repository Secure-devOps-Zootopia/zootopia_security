# AWS region variable
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# S3 bucket name
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-example-bucket"
}

# S3 bucket ACL
variable "bucket_acl" {
  description = "Access control list for the S3 bucket"
  type        = string
  default     = "private"
}
