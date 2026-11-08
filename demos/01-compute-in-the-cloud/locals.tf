locals {
  demo_name = "01-compute-in-the-cloud"

  default_tags = {
    Environment = "learning"
    ManagedBy   = "Terraform"
    Project     = "aws-cloud-practitioner"
    Lesson      = local.demo_name
  }
}
