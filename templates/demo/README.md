# Demo template

This directory is a starter template for a Terraform root module in this repository.

## Purpose

Use this template as the starting point for a new lesson demo. Copy the template files into a new `demos/<lesson-name>/` directory, then customize the configuration for the scenario you want to deploy.

## Included files

- `locals.tf` - Demo-specific default tags and naming values.
- `providers.tf` - AWS provider configuration.
- `variables.tf` - Shared demo variables such as region and instance size.
- `versions.tf` - Required Terraform and provider versions, plus Terraform Cloud workspace metadata.

## Required updates

Before using the template, replace the placeholder values in the files:

- `REPLACE_WITH_DEMO_NAME`
- `REPLACE_WITH_TERRAFORM_CLOUD_ORGANIZATION`
- `REPLACE_WITH_TERRAFORM_CLOUD_WORKSPACE`

Then add your actual Terraform resources in `main.tf` and remove variables that are not needed by the demo.

## Typical workflow

```powershell
New-Item -ItemType Directory demos\02-your-demo
Copy-Item templates\demo\*.tf demos\02-your-demo\
```

From the new demo directory:

```shell
terraform init
terraform plan
terraform apply
terraform destroy
```

## Notes

- Each demo should have its own Terraform state and workspace.
- Keep AWS credentials outside the repository and configure them through Terraform Cloud or your local environment.
- Review the plan before applying and destroy resources when the lesson is complete.
