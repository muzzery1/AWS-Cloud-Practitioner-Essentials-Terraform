variable "queue_name" {
  description = "Name of the SQS queue."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to the SQS queue."
  type        = map(string)
  default     = {}
}
