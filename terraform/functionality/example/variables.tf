variable "aws_region" {
  description = "The region aws"
  default     = ""
}

variable "project" {
  type        = string
  description = "value of project"
}

variable "account_id" {
  description = "The account ID aws"
  type        = string
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 zone id"
}
