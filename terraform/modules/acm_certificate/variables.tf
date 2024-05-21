variable "domain_name" {
  type        = string
  description = "The domain name."
}

variable "validation_method" {
  type        = string
  description = "The validate method for certification."
}

variable "create_before_destroy" {
  description = "Create certification before destroy."
}
