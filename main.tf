terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# CREA UNA VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "VPC-Terraform-Demo"
  }
}

##CREA UNA SUBNET
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  tags = {
    Name = "Sunet-Terraform-Demo"
  }
}

#SECURITY GROUP
resource "aws_security_group" "main" {
  name        = "secGroup-terraform-demo-ec2"
  description = "Security group for Terraform demo"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Terraform-Demo-EC2"
  }
}

## iGW para salida/entrada a Internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW-Terraform-Demo"
  }
}

## ROUTE TABLE FOR INTERNET
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "RT-Public-Terraform-Demo" }
}

# Asociar la RT pública a tu subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}


#MAQUINA VIRTUAL (EC2)
resource "aws_instance" "server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -e
    yum update -y || apt-get update -y
    # Amazon Linux 2 / 2023:
    yum install -y nginx || true
    systemctl enable nginx || true
    systemctl start nginx || true
    echo "<h1>Hola desde Terraform</h1>" > /usr/share/nginx/html/index.html || true
  EOF
  
  tags = {
    Name = "Terraform-Demo-Instance"
  }
}
