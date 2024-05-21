output "vpc_id" {
  description = "The VPC id"
  value       = module.vpc-subnet-internet_gateway.vpc_id
}

output "subnet_ids" {
  description = "List Id of subnet"
  value       = module.vpc-subnet-internet_gateway.subnet_ids
}

output "vpc_cidr_block" {
  description = "The VPC cidr block"
  value       = module.vpc-subnet-internet_gateway.vpc_cidr_block
}

output "backend_security_group_id" {
  description = "Backend (ECS) security groups ID"
  value       = module.security_group.backend_security_group_id
}

output "backend_security_group_name" {
  description = "Backend (ECS) security groups name"
  value       = module.security_group.backend_security_group_name
}

output "rds_security_group_id" {
  description = "RDS (database) security groups ID"
  value       = module.security_group.rds_security_group_id
}

output "rds_security_group_name" {
  description = "RDS (database) security groups name"
  value       = module.security_group.rds_security_group_name
}

output "s3_bucket_photo_image" {
  description = "Photo image bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "target_group_arn_suffix" {
  description = "Photo image bucket"
  value       = module.load_balancing.target_group_arn_suffix
}

output "lb_arn_suffix" {
  description = "The ALB target group ARN"
  value       = module.load_balancing.lb_arn_suffix
}

output "cloudwatch_log_group_name" {
  description = "The cloudwatch log name"
  value       = aws_cloudwatch_log_group.cloudwatch_group.name
}

output "cloudwatch_log_group_arn" {
  description = "The cloudwatch log arn"
  value       = aws_cloudwatch_log_group.cloudwatch_group.arn
}
