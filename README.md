# AWS Cloud Practitioner Terraform demos

This repository is a learning lab and portfolio built alongside the [AWS Cloud Practitioner Essentials course](https://skillbuilder.aws/learn/94T2BEN85A/aws-cloud-practitioner-essentials/8D79F3AVR7). Each lesson demo is an independent Terraform root module so it can be planned, deployed, and destroyed without sharing Terraform state with other lessons.

## Repository layout

```text
demos/
  01-compute-in-the-cloud/   Independent Terraform root module for lesson 01
modules/
  ec2/                       Reusable EC2 instance child module
templates/
  demo/                      Starter Terraform files for new demos
```

### Demos

Each directory under `demos/` is an independent Terraform root module. Run Terraform commands from that directory. Each demo owns its Terraform Cloud workspace and state. For VCS-driven Terraform Cloud runs, set the workspace's working directory to the demo directory. See the [demo 01 guide](./demos/01-compute-in-the-cloud/README.md) for its architecture, access limitations, and cost notes.

Using one workspace per demo isolates Terraform state, but it does not prevent AWS charges. Always review the plan and destroy temporary resources when finished.

### Modules

Modules are child components called by root modules. The `modules/ec2/` module creates only an EC2 instance; callers provide its AMI, subnet, security groups, and common tags. The module merges the supplied tags with its resource-specific `Name` tag.

Each demo configures its own AWS provider, versions, tags, and Terraform Cloud workspace because Terraform roots are independent. Use `templates/demo/` as a starting point for new demos; copy the files, replace the demo and Terraform Cloud placeholders, then remove any variables the demo does not use. Tags are passed explicitly to resources and child modules rather than applied implicitly by provider `default_tags`.

## Credentials and Terraform Cloud

Provider configuration belongs to each demo root. AWS credentials do not: supply them through Terraform Cloud workspace/variable-set configuration or, preferably, Terraform Cloud dynamic credentials with an appropriately scoped AWS IAM role. Never commit access keys, Terraform state, or secret variable files.

The Terraform Cloud organization and workspace are configured in each demo's `versions.tf`. Update those values to match your Terraform Cloud account before initializing the demo.

## VS Code tasks

Open the repository folder in VS Code, then choose **Terminal > Run Task** and select a task:

- **Terraform: Format All** runs `terraform fmt -recursive` from the repository root. It formats Terraform files in place; review the resulting changes before committing.
- **Terraform: Validate All** initializes and validates each immediate Terraform configuration directory under `demos/`, `modules/`, and `templates/`. Initialization uses `-backend=false`, so it does not connect to Terraform Cloud or access remote state. Terraform and provider plugins must be installed locally; the first initialization may download providers. The task uses PowerShell and stops if initialization or validation fails.
- **Terraform: Init and Plan demo 01** initializes `demos/01-compute-in-the-cloud/` with its configured HCP Terraform backend, then runs `terraform plan`. It does not apply changes. Run `terraform login` first and ensure the HCP Terraform workspace and AWS provider credentials are configured. Review the plan before applying or deploying resources.

## Running a demo

For example, from `demos/01-compute-in-the-cloud/`:

```shell
terraform init
terraform plan
terraform apply
terraform destroy
```

`terraform plan` is a review step, not a guarantee of zero cost. Check the resources and current AWS pricing before applying. See [demo 01](./demos/01-compute-in-the-cloud/README.md) for details.

## Starting a new demo

For example, in PowerShell create a new demo folder and copy the starter files:

```powershell
New-Item -ItemType Directory demos\02-your-demo
Copy-Item templates\demo\*.tf demos\02-your-demo\
```

Replace `REPLACE_WITH_DEMO_NAME`, `REPLACE_WITH_TERRAFORM_CLOUD_ORGANIZATION`, and `REPLACE_WITH_TERRAFORM_CLOUD_WORKSPACE`. Add the lesson's resources in `main.tf`, pass `local.default_tags` to taggable resources and child modules, and remove unused template variables. Each demo needs its own Terraform Cloud workspace and lock file.

## Compatibility and quality checks

Each root module declares the Terraform and provider versions it uses and should commit its own `.terraform.lock.hcl`. Run `terraform fmt -recursive -check` from the repository root, and run `terraform validate` from each demo directory when making changes. The HCP plan check verifies the demo against the configured remote workspace and provider credentials without applying changes.
