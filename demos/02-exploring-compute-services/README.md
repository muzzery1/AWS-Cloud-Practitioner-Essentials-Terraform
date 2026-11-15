# Demo 02: Exploring compute services

This lesson deploys an Amazon SQS FIFO queue and a Node.js AWS Lambda function that processes messages from the queue and logs their IDs and bodies to CloudWatch Logs.

## What this demonstrates

- A demo directory is a Terraform root module with its own Terraform Cloud workspace and state.
- The root module creates an SQS FIFO queue and passes its ARN to a reusable Lambda child module.
- The Lambda module packages the handler, creates the function and execution role, grants queue polling and CloudWatch Logs permissions, and connects the queue to the function with an event source mapping.
- The queue uses content-based deduplication and one-day message retention. Its 360-second visibility timeout is six times the Lambda's 60-second timeout; the event source mapping reads batches of up to 10 messages.

## Queue and access

After deployment, send a test message manually from the AWS console using the queue's **Send and receive messages** page. FIFO queues require a message group ID. With content-based deduplication enabled, identical message bodies sent within the deduplication interval may be treated as duplicates.

The Lambda polls the queue and logs each received message to `/aws/lambda/02-exploring-compute-services-lambda`. Allow a short time for polling, then inspect the function's CloudWatch Logs log group.

The Lambda execution role can receive, delete, and inspect messages in this queue, and write logs to the function's log group. The identity used to send a message from the console separately needs `sqs:SendMessage` on the queue, as well as permissions to view and use the queue in the console.

## Cost and cleanup

The queue, Lambda invocations, and CloudWatch Logs storage and ingestion can incur charges while deployed or in use. Charges depend on message volume, log volume, account, and region. Review the plan before applying and run `terraform destroy` when finished.

## Run

From this directory, initialize and review the plan before applying:

```shell
terraform init
terraform plan
terraform apply
terraform destroy
```

AWS credentials must be configured outside this repository, preferably with Terraform Cloud dynamic credentials. Do not put access keys in Terraform files or commit them to Git.

For VCS-driven Terraform Cloud runs, set this workspace's working directory to `demos/02-exploring-compute-services` so the run uses this root module.

## VS Code tasks

In VS Code, run **Terminal > Run Task > Terraform: Init and Plan demo 02** to initialize this root with its configured HCP Terraform backend and create a plan without applying it. Authenticate the Terraform CLI with `terraform login` and configure AWS provider credentials in the HCP Terraform workspace before running the task. Review the plan and potential costs before applying changes.
