# Zootopia E-Commerce Platform - Terraform Infrastructure
# This manages the staging environment for the Zootopia application

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "Zootopia"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# ==========================================
# VPC and Networking
# ==========================================
resource "aws_vpc" "zootopia_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "zootopia-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.zootopia_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "zootopia-${var.environment}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.zootopia_vpc.id

  tags = {
    Name = "zootopia-${var.environment}-igw"
  }
}

# ==========================================
# EKS Cluster for Kubernetes
# ==========================================
resource "aws_eks_cluster" "zootopia_cluster" {
  name     = "zootopia-${var.environment}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = aws_subnet.public_subnet[*].id
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "zootopia-${var.environment}-eks"
  }
}

# ==========================================
# S3 Buckets for Application Data
# ==========================================
resource "aws_s3_bucket" "zootopia_assets" {
  bucket = "${var.project_name}-${var.environment}-assets"

  tags = {
    Name        = "Zootopia Assets Bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "assets_versioning" {
  bucket = aws_s3_bucket.zootopia_assets.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets_encryption" {
  bucket = aws_s3_bucket.zootopia_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ==========================================
# RDS Database (PostgreSQL)
# ==========================================
resource "aws_db_subnet_group" "zootopia_db_subnet" {
  name       = "zootopia-${var.environment}-db-subnet"
  subnet_ids = aws_subnet.public_subnet[*].id

  tags = {
    Name = "Zootopia DB subnet group"
  }
}

resource "aws_db_instance" "zootopia_db" {
  identifier           = "zootopia-${var.environment}-db"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = var.db_instance_class
  allocated_storage    = 20
  storage_encrypted    = true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.zootopia_db_subnet.name
  
  backup_retention_period = 7
  skip_final_snapshot     = true
  
  tags = {
    Name = "zootopia-${var.environment}-postgres"
  }
}

# ==========================================
# IAM Roles for EKS
# ==========================================
resource "aws_iam_role" "eks_cluster_role" {
  name = "zootopia-${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# ==========================================
# Data Sources
# ==========================================
data "aws_availability_zones" "available" {
  state = "available"
}

# ==========================================
# Outputs
# ==========================================
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.zootopia_vpc.id
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.zootopia_cluster.endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.zootopia_cluster.name
}

output "s3_bucket_name" {
  description = "S3 bucket for assets"
  value       = aws_s3_bucket.zootopia_assets.bucket
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.zootopia_db.endpoint
}
