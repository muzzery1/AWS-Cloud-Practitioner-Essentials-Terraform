variable "aws_region" {
  description = "AWS region in which to deploy this lesson."
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "EC2 instance type used for this lesson."
  type        = string
  default     = "t3.micro"
}