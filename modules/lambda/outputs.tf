output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.fifo_queue_nodejs_lambda.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function."
  value       = aws_lambda_function.fifo_queue_nodejs_lambda.arn
}