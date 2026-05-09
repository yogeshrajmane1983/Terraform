variable "aws_region" {
  description = "AWS region to deploy resources"
    type        = string
    default     = "ap-south-1"
}

variable "env_name" {
    type = string
    default = "dev"
}

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_newbits" {
    description = "Number of new bits to add to VPC CIDR to generate subnets (e.g., 8 means /24 from /16)"
    type = number
    default = 8
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {
    Terraform = "true"
  }
}