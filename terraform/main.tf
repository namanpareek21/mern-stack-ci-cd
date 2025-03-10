terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC

resource "aws_default_vpc" "default" {
  
}
resource "aws_security_group" "allow_user_to_connect" {
   name        = "allow TLS"
  description = "Allow user to connect"
  vpc_id      = aws_default_vpc.default.id
}
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_user_to_connect.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  
}

# Allow SSH traffic (port 22)
resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.allow_user_to_connect.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
# Allow HTTP traffic (port 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allow HTTPS traffic (port 443)
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
# Allow Jenkins 
resource "aws_vpc_security_group_ingress_rule" "Jenkins" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
#Allow redis
resource "aws_vpc_security_group_ingress_rule" "Redis" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6379
  ip_protocol       = "tcp"
  to_port           = 6379
}
#Allow SmtpS
resource "aws_vpc_security_group_ingress_rule" "SMTPS" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 465
  ip_protocol       = "tcp"
  to_port           = 465
  
}
#Allow Application Ports
resource "aws_vpc_security_group_ingress_rule" "Application" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 10000
}
#Allow Smtp

resource "aws_vpc_security_group_ingress_rule" "SMTP" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25
  ip_protocol       = "tcp"
  to_port           = 25
}
#allow k8s
resource "aws_vpc_security_group_ingress_rule" "K8s" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6443
  ip_protocol       = "tcp"
  to_port           = 6443
}
resource "aws_vpc_security_group_ingress_rule" "Kubernetes_Node_Ports" {
  security_group_id = aws_security_group.allow_user_to_connect.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30000
  ip_protocol       = "tcp"
  to_port           = 32767
}

resource "aws_instance" "Demo" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.large"
  key_name = "master"
  security_groups = [aws_security_group.allow_user_to_connect.name]
  user_data = file("install.sh")

  tags = {
    Name = "Demo"
  }
  root_block_device {
    volume_size = 30   # Disk space in GB
    volume_type = "gp3"  
  }
}