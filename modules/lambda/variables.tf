variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to the Lambda function."
  type        = map(string)
  default     = {}
}

variable "source_dir" {
  type    = string
  default = null
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to which the Lambda function will be connected."
  type        = string
}