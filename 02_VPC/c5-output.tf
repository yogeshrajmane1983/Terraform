output "vpc_id" {
  value = aws_vpc.vpc.id
  description = "VPC id"
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public_subnet : s.id]
  description = "Public Subnet Ids"
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private_subnet : s.id]
  description = "Private Subnet Ids"
}

output "public_subnet_map" {
    value = {for az, subnet in aws_subnet.public_subnet : az => subnet.id}
    description = "Map of AZ to Public Subnet ID"
}

output "private_subnet_map" {
    value = {for az, subnet in aws_subnet.private_subnet : az => subnet.id}
    description = "Map of AZ to Private Subnet ID"
}