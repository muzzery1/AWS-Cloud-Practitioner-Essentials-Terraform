# Demo 01: Compute in the cloud

This lesson deploys a small Amazon Linux 2023 EC2 instance into a private subnet in a VPC created by this demo.

## What this demonstrates

- A demo directory is a Terraform root module with its own Terraform Cloud workspace and state.
- The root module owns the network and passes the subnet, security group, and AMI into a reusable EC2 child module.
- The root module passes its default tags to the VPC and EC2 child module; the instance requires IMDSv2 and uses an encrypted root volume.
- Terraform data sources look up available Availability Zones and the specifically selected Amazon Linux 2023 AMI.

## Network and access

The instance is in a private subnet with no public IP, Internet Gateway, or NAT Gateway, so it has no Internet connectivity. Its VPC's default security group allows inbound traffic only from interfaces using that same group; no outside access is configured. This demo does not set up SSH or Systems Manager access. Inspect the instance and its outputs in Terraform Cloud or the AWS console.

The root module defines baseline tags in `locals.tf` and passes them to the VPC and EC2 module. The EC2 module combines those tags with its resource-specific `Name` tag. The instance requires IMDSv2 and encrypts its root EBS volume.

The private IP output is only reachable from a network with connectivity into this VPC. This demo provides no VPN, bastion host, or Systems Manager access path, so the output is informational unless you add an access method.

## Cost and cleanup

The EC2 instance and its root EBS volume can incur charges while deployed. The configuration avoids NAT Gateway and public IPv4 costs, but AWS pricing and Free Tier eligibility depend on your account and region. The AMI name is pinned to a specific Amazon Linux 2023 build; availability depends on the selected region. Review the plan before applying and run `terraform destroy` when finished.

## Run

From this directory, initialize and review the plan before applying:

```shell
terraform init
terraform plan
terraform apply
terraform destroy
```

AWS credentials must be configured outside this repository, preferably with Terraform Cloud dynamic credentials. Do not put access keys in Terraform files or commit them to Git.

For VCS-driven Terraform Cloud runs, set this workspace's working directory to `demos/01-compute-in-the-cloud` so the run uses this root module.
