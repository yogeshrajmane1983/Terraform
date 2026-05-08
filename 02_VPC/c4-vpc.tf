# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  # Use merge function to merge the two maps
  # merge takes an arbitrary number of maps or objects,
  # and returns a single map or object that contains a merged set of elements from all arguments.
  tags = merge(var.tags, {Name = "${var.env_name}-vpc"})
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags, {Name = "${var.env_name}-igw"})
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  for_each = {for index, az in local.az_list : az => local.public_subnets_cidr[index]}
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags, {Name = "${var.env_name}-public-${each.key}"})
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  for_each = {for index, az in local.az_list : az => local.private_subnet_cidr[index]}
  vpc_id = aws_vpc.vpc.id 
  cidr_block = each.value
  availability_zone = each.key
  tags = merge(var.tags, {Name = "${var.env_name}-private-${each.key}"})
}

# Nat Gateway Elastic IP
resource "aws_eip" "nat_eip" {
  tags = merge(var.tags, {Name = "${var.env_name}-nat_eip"})
}

# Nat Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = values(aws_subnet.public_subnet)[0].id
  depends_on = [ aws_internet_gateway.igw ]
  tags = merge(var.tags, {Name = "${var.env_name}-nat-gw"})
}

# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, {Name = "${var.env_name}-public_rt"})
}

# Public route table association to Public subnet
resource "aws_route_table_association" "public_rt_association" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# Pritae route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.nat-gw.id
  }
  tags = merge(var.tags, {Name = "${var.env_name}-private_rt"})
}

# Private route table association to Pricate subnet
resource "aws_route_table_association" "private_rt_association" {
  for_each = aws_subnet.private_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

