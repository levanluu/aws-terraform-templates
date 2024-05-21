variable "project" {
  type        = string
  description = "value of project"
}

variable "security_group_ids" {
  description = "The list of security group."
  default     = []
  type        = list(any)
}

variable "subnet_ids" {
  description = "The list of subnet."
  default     = []
  type        = list(any)
}

variable "vpc_id" {
  description = "The VPC id."
  default     = ""
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of ACM certificate."
  default     = ""
  type        = string
}

variable "health_check_path" {
  description = "The health check path."
  default     = ""
  type        = string
}
