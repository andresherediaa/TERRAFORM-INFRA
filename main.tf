terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}


# Recurso de ejemplo: una VPC simple
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "demo-vpc"
    Environment = "dev"
  }
}