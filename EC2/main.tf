# XXX - This will require more thought on structure.  Having modules is great
#       but the exercise is useless if hacked together and in bad form.
#
#       This is trivial, there shouldn't be much difficulty but creating the
#       first module will take a little longer given the overview.

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
  filename = "Dev-Node"#module.aws_instance.tags.Name
}