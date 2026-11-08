terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92"
    }
  }

  cloud {
    organization = "REPLACE_WITH_TERRAFORM_CLOUD_ORGANIZATION"

    workspaces {
      name = "REPLACE_WITH_TERRAFORM_CLOUD_WORKSPACE"
    }
  }
}
