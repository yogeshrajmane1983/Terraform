# Declare the data source for AZs
data "aws_availability_zones" "available_azs" {
  state = "available"
}

locals {
  #Get the first 3 available Azs from the region
  az_list = slice(data.aws_availability_zones.available_azs.names, 0, 3)
  #Use For loop to iterate through the data 'available_azs'. Use cidrsubnet function to create subnet cidr range
  public_subnets_cidr = [for k, az in local.az_list : cidrsubnet(var.vpc_cidr_block, var.subnet_newbits, k)]
  private_subnet_cidr = [for k, az in local.az_list : cidrsubnet(var.vpc_cidr_block, var.subnet_newbits, k+10)]
}