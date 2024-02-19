variable "project_name" {
  description = "The name of project."
  default     = ""
  type        = string
}

# S3 BUCKET
variable "bucket_state_storage_name" {
  description = "The name of S3 bucket to store state files."
  default     = ""
  type        = string
}
