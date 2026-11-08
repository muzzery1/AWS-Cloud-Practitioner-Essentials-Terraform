# Data
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  filter {
    name   = "name"
    values = ["al2023-ami-2023.12.20260918.0-kernel-6.18-x86_64"]
  }

  owners = ["137112412989"]
}

# Modules
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = local.demo_name
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0]]
  private_subnets = ["10.0.1.0/24"]

  enable_dns_hostnames = true
  enable_nat_gateway   = false
  create_igw           = false

  tags = local.default_tags
}

module "ec2" {
  source = "../../modules/ec2"

  ami_id                 = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  instance_name          = local.demo_name
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  tags                   = local.default_tags
}