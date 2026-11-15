# Lambda consumer module

This Terraform child module deploys a Node.js Lambda function that consumes
messages from an existing SQS queue.

## What it includes

- A deployment ZIP archive built from the supplied source directory.
- A Lambda execution role and inline policy granting the queue polling
  permissions and CloudWatch Logs write access scoped to this function's log
  group.
- The Lambda function and its CloudWatch log group.
- An SQS event source mapping, created after the execution policy is attached.

The function uses the `index.handler` handler with the `nodejs24.x` runtime.
The source directory must contain a compatible `index.mjs` (or equivalent
handler package) and the function's handler entry point.

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `function_name` | `string` | Yes | Lambda function name. Also used to name its execution role, policy, and log group. |
| `source_dir` | `string` | Yes | Directory containing the Lambda handler source to package. |
| `sqs_queue_arn` | `string` | Yes | ARN of the SQS queue to consume. |
| `tags` | `map(string)` | No | Tags applied to the Lambda function. Defaults to `{}`. |

## Example

```hcl
module "queue_consumer" {
  source = "../modules/lambda"

  function_name = "example-queue-consumer"
  source_dir    = "${path.root}/lambda"
  sqs_queue_arn = module.sqs.queue_arn

  tags = {
    Environment = "learning"
  }
}
```

The queue must already exist and be compatible with Lambda's SQS event source
mapping. The identity running Terraform must be able to create the AWS
resources; the Lambda role's SQS permissions do not grant the Terraform
operator or console user permission to send test messages.

## Outputs

- `function_name` - Name of the deployed Lambda function.
- `function_arn` - ARN of the deployed Lambda function.

The Lambda execution role can receive, delete, and inspect queue messages. Its
CloudWatch Logs permissions are scoped to `/aws/lambda/<function_name>` and that
log group's streams.
