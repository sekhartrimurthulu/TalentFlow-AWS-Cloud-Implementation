output "vpc_id" {
  description = "TalentFlow VPC ID"
  value       = aws_vpc.talentflow.id
}

output "vpc_cidr" {
  description = "TalentFlow VPC CIDR"
  value       = aws_vpc.talentflow.cidr_block
}

output "internet_gateway_id" {
  description = "TalentFlow Internet Gateway ID"
  value       = aws_internet_gateway.talentflow_igw.id
}
output "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "Private subnet 1 ID"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "Private subnet 2 ID"
  value       = aws_subnet.private_2.id
}

output "nat_gateway_id" {
  description = "TalentFlow NAT Gateway ID"
  value       = aws_nat_gateway.talentflow_nat.id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}