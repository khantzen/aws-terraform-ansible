terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}


resource "aws_instance" "demo_site" {
  ami           = "ami-0d3f551818b21ed81"
  instance_type = "t2.micro"
  
  key_name = "admin_key"

  vpc_security_group_ids = [
    aws_security_group.linux.id
  ]

}

resource "aws_eip" "instance_ip" {
  vpc = true
  instance = aws_instance.demo_site.id
}

output "ip" {
  value = aws_eip.instance_ip.public_ip
}