output "vpc_id" {
  description = "The VPC id"
  value       = aws_vpc.vpc.id
}

output "subnet_ids" {
  description = "List Id of subnet"
  value       = aws_subnet.public_subnet.*.id
}

output "vpc_cidr_block" {
  description = "The VPC cidr block"
  value       = aws_vpc.vpc.cidr_block
}