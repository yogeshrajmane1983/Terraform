#Terrafform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {

    #AWS provider
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

#Provider Block

provider "aws" {
  region = var.aws_region
}

