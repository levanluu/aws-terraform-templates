variable "project_name" {
  description = "The name of project."
  default     = ""
  type        = string
}

variable "environments" {
  description = "The list of environments."
  default     = [{ name = "dev", region = "ap-northeast-1" }]
  type = list(object({
    name   = string,
    region = string
  }))
}

# S3 BUCKET
variable "bucket_state_storage_name" {
  description = "The name of S3 bucket to store state files."
  default     = ""
  type        = string
}
