variable "project" {
  type        = string
  description = "value of project"
}

variable "environment_name" {
  description = "The name of enviroment use to  iac"
  default     = ""
}

variable "event_queue_name" {
  description = "The SQS uploaded firmware queue name."
  default     = ""
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 30
}

variable "source_arn" {
  description = "The source ARN to recived message."
  default     = ""
}

variable "dead_letter_queue_arn" {
  description = "The dead letter queue ARN."
  default     = ""
}

variable "dead_letter_queue_max_receive_count" {
  description = "The dead letter queue max receive count."
  default     = 3
}
