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

variable "host_name" {
  description = "The main host name."
  default     = ""
  type        = string
}

# S3 BUCKET
variable "bucket_state_storage_name" {
  description = "The name of S3 bucket to store state files."
  default     = ""
  type        = string
}

# OIDC
variable "repositories" {
  description = "The repositories org."
  default     = []
  type        = list(any)
}

# Monitoring billing
variable "slack_webhook_url" {
  description = "slack webhook url."
  default     = ""
  type        = string
}
