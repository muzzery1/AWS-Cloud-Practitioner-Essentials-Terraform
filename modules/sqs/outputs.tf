output "queue_name" {
  description = "Name of the SQS queue."
  value       = aws_sqs_queue.fifo_queue.name
}

output "queue_arn" {
  description = "ARN of the SQS queue."
  value       = aws_sqs_queue.fifo_queue.arn
}