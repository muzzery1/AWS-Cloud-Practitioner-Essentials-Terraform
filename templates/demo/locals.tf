locals {
  demo_name = "REPLACE_WITH_DEMO_NAME"

  default_tags = {
    Environment = "learning"
    ManagedBy   = "Terraform"
    Project     = "aws-cloud-practitioner"
    Lesson      = local.demo_name
  }
}
