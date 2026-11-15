locals {
  demo_name = "02-exploring-compute-services"

  default_tags = {
    Environment = "learning"
    ManagedBy   = "Terraform"
    Project     = "aws-cloud-practitioner"
    Lesson      = local.demo_name
  }
}
