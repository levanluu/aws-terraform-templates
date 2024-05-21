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

# DynamoDB
variable "bucket_state_state_locking" {
  description = "The name of DynamoDB store state lockID."
  default     = ""
  type        = string
}
