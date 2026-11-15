# SQS FIFO queue module

This Terraform child module creates an encrypted Amazon SQS FIFO queue for the
AWS Cloud Practitioner learning demos.

## What it includes

- FIFO queue naming (the module appends `.fifo` to `queue_name`).
- Content-based deduplication and SQS-managed server-side encryption.
- One-day message retention and a 360-second visibility timeout.
- Tag merging with a queue-specific `Name` tag.

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `queue_name` | `string` | Yes | Queue name without the `.fifo` suffix. |
| `tags` | `map(string)` | No | Common tags to merge with the queue's `Name` tag. Defaults to `{}`. |

## Example

```hcl
module "sqs" {
  source = "../modules/sqs"

  queue_name = "example-queue"
  tags = {
    Environment = "learning"
  }
}
```

When manually sending a message to this FIFO queue in the AWS Console, provide
a message group ID. With content-based deduplication enabled, identical
message bodies sent within the deduplication interval may be deduplicated.
Grant `sqs:SendMessage` to the identity that sends the test message; the queue
module does not create permissions for that identity.

## Outputs

- `queue_name` - Fully qualified queue name, including `.fifo`.
- `queue_arn` - ARN of the queue, suitable for configuring a Lambda event
  source mapping and its queue permissions.
