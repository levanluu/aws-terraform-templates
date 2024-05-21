variable "project" {
  type        = string
  description = "value of project"
}

variable "vpc_id" {
  description = "The vpc id."
  type        = string
}

variable "security_group_http_cidr_blocks" {
  type        = list(string)
  description = "The list of CIDR blocks for http"
}

variable "security_group_http_ipv6_cidr_blocks" {
  type        = list(string)
  description = "The list of CIDR blocks for http"
}

variable "security_group_https_cidr_blocks" {
  type        = list(string)
  description = "The list of CIDR blocks for https"
}

variable "security_group_https_ipv6_cidr_blocks" {
  type        = list(string)
  description = "The list of CIDR blocks for https"
}

variable "rds_security_group_cidr_blocks" {
  type        = list(string)
  description = "The list of CIDR blocks for RDS"
}
