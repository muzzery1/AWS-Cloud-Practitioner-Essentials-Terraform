# EC2 instance module

This Terraform child module creates a single EC2 instance for the AWS Cloud Practitioner learning demos.

## What it includes

- `aws_instance.app_server`
- Required IMDSv2 metadata configuration (`http_tokens = "required"`)
- Encrypted root EBS volume
- Tag merging with a resource-specific `Name` tag
- Simple outputs for the instance ID and private IP

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `instance_name` | `string` | Yes | Value used for the EC2 instance `Name` tag. |
| `instance_type` | `string` | Yes | EC2 instance size. |
| `ami_id` | `string` | Yes | AMI ID to launch. |
| `subnet_id` | `string` | Yes | Subnet in which the instance is placed. |
| `vpc_security_group_ids` | `list(string)` | Yes | Security group IDs attached to the instance. |
| `tags` | `map(string)` | No | Common tags to merge with the instance tags. Defaults to `{}`. |

## Example

```hcl
module "app_server" {
  source = "../modules/ec2"

  instance_name          = "demo-app"
  instance_type          = "t3.micro"
  ami_id                 = data.aws_ami.amazon_linux_2023.id
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.app.id]

  tags = {
    Environment = "learning"
    Project     = "aws-cloud-practitioner"
  }
}
```

## Outputs

- `instance_id` - The EC2 instance ID.
- `instance_private_ip` - The private IP address of the EC2 instance.

## Notes

This module is intentionally small and focused. Root modules remain responsible for VPC, subnet, security group, AMI lookup, tagging strategy, and provider configuration.
