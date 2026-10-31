provider "aws" {
  region = "eu-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    # Match the Amazon Linux 2023 AMI naming convention. Find the exact name
    # and current kernel version in the EC2 AMI catalog or with describe-images.
    values = ["al2023-ami-2023.12.20260918.0-kernel-6.18-x86_64"]
  }

  # Amazon's AWS account ID; the owner filter avoids matching third-party AMIs.
  owners = ["137112412989"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "learn-hcp-terraform"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_dns_hostnames = true
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Name = var.instance_name
  }
}
