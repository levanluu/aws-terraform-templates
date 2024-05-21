output "acm_certificate_arn" {
  description = "ARN of ACM certificate"
  value       = aws_acm_certificate.cert.arn
}

output "domain_validation_options" {
  description = "ARN of ACM certificate"
  value       = aws_acm_certificate.cert.domain_validation_options
}
