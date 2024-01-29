terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>4"
        }
    }
}
provider "aws" {
    profile = "tijko"
    region = "us-east-1"
}