terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


variable "region" {
default = "ap-south-1"
}

provider "aws" {
  profile = "default"
  region = var.region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}



variable "images" {
default = "ami-08f63db601b82ff5f"
}


variable "env" {}

variable "EC2name" {
    type = map(any)
    default = {
        stage = "ec2-stage-instance"
        prod = "ec2-prod-instance"
    }  
}

resource "aws_instance" "ec2-stage-instance" {
ami = var.images
instance_type = "t2.micro"
user_data = file("user_data.sh")

tags = {
    Name = "ec2-stage-instance"
  }

}


resource "aws_instance" "ec2-prod-instance" {

    
ami = var.images
instance_type = "t2.micro"
user_data = file("user_data.sh")

tags = {
    Name = "ec2-prod-instance"
  }

}

output "Private-ip" {
  value = var.env == "prod" ? aws_instance.ec2-prod-instance.private_ip : aws_instance.ec2-stage-instance.private_ip
  description = "ec2-$var.env-instance"
}
