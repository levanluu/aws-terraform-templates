output "alb_arn" {
  description = "The ALB ARN"
  value       = aws_lb.lb.arn
}

output "aws_lb_target_group_arn" {
  description = "The ALB target group ARN"
  value       = aws_lb_target_group.lb_target_group.arn
}

output "target_group_arn_suffix" {
  description = "The ALB target group ARN"
  value       = aws_lb_target_group.lb_target_group.arn_suffix
}

output "lb_arn_suffix" {
  description = "The ALB target group ARN"
  value       = aws_lb.lb.arn_suffix
}

output "dns_name" {
  description = "The DNS name"
  value       = aws_lb.lb.dns_name
}

output "zone_id" {
  description = "The zone ID"
  value       = aws_lb.lb.zone_id
}
