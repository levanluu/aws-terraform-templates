output "backend_security_group_id" {
  description = "Backend (ECS) security groups ID"
  value       = aws_security_group.backend_security_group.id
}

output "backend_security_group_name" {
  description = "Backend (ECS) security groups name"
  value       = aws_security_group.backend_security_group.name
}

output "rds_security_group_id" {
  description = "RDS (database) security groups ID"
  value       = aws_security_group.rds_database_security_group.id
}

output "rds_security_group_name" {
  description = "RDS (database) security groups name"
  value       = aws_security_group.rds_database_security_group.name
}
