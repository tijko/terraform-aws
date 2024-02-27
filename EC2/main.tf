
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "tijko"
}

module "aws_instance" {
  source = "./modules/aws-instances"
}

resource "local_file" "aws_ec2_ips" {
  content  = tostring("${module.aws_instance.aws_ec2_ips}" [0])
  filename = "Dev-Node"
}