# Terraform configuration for AWS EC2 instances (Optional)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "petclinic_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "petclinic-vpc"
  }
}

# Subnet
resource "aws_subnet" "petclinic_subnet" {
  vpc_id                  = aws_vpc.petclinic_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "petclinic-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "petclinic_igw" {
  vpc_id = aws_vpc.petclinic_vpc.id

  tags = {
    Name = "petclinic-igw"
  }
}

# Security Group
resource "aws_security_group" "petclinic_sg" {
  name        = "petclinic-sg"
  description = "Security group for PetClinic application"
  vpc_id      = aws_vpc.petclinic_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "petclinic-sg"
  }
}

# EC2 Instance
resource "aws_instance" "petclinic_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.petclinic_subnet.id
  
  vpc_security_group_ids = [aws_security_group.petclinic_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker run -d -p 8080:8080 samagyasapkota/spring-petclinic:latest
              EOF

  tags = {
    Name = "petclinic-app-server"
  }
}
