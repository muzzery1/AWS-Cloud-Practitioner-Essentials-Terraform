variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID in which to place the EC2 instance."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to associate with the EC2 instance."
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply to the EC2 instance."
  type        = map(string)
  default     = {}
}
