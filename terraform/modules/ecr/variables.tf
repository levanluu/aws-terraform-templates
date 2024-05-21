variable "project" {
  type        = string
  description = "value of project"
}

variable "mutability" {
  type        = string
  description = "The tag mutability setting for the repository."
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
}
