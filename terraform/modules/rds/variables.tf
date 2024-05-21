variable "project" {
  type        = string
  description = "value of project"
}

variable "engine" {
  description = "The database engine to use."
  type        = string
}

variable "engine_version" {
  description = "(Optional) The engine version to use"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "db_name" {
  description = "The database name."
  type        = string
}

variable "username" {
  description = "The username."
  type        = string
}

variable "password" {
  description = "The password."
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = string
}

variable "storage_type" {
  description = "The amount of provisioned IOPS."
  type        = string
}

variable "database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  type        = number
}

variable "security_group_ids" {
  description = "List of DB Security Groups to associate."
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of DB Security Groups to associate."
  type        = list(any)
}
