variable "aws_region" {
  description = "The region aws"
  default     = ""
}

variable "project" {
  type        = string
  description = "value of project"
}

variable "domain_name" {
  type        = string
  description = "value of omain_name"
}

# VPC
variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR Block."
  default     = []
  type        = list(any)
}

variable "rds_security_group_cidr_blocks" {
  description = "Public Subnet CIDR Block."
  default     = []
  type        = list(any)
}

# RDS
variable "instance_class" {
  description = "The instance class to use."
  default     = ""
}

variable "db_name" {
  description = "The name of the database to create."
  default     = ""
}

variable "username" {
  description = "The username of the database to create."
  default     = ""
}

variable "password" {
  description = "The password of the database to create."
  default     = ""
}

variable "allocated_storage" {
  description = "The allocated storage size for the database."
  default     = ""
}
