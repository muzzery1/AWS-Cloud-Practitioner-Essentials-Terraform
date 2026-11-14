terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92"
    }
  }

  cloud {
    organization = "muzzery1-org"

    workspaces {
      name = local.demo_name
    }
  }
}
