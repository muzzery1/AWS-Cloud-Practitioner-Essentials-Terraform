# Archive the Lambda function code into a zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = ".terraform/tmp/lambda/${var.function_name}.zip"
}

# 1. Trust policy allowing Lambda to assume the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${var.function_name}-lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.function_name}"
}

# 2. Permissions policy for SQS and CloudWatch Logs
data "aws_iam_policy_document" "lambda_sqs_logs" {
  # SQS polling permissions
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [var.sqs_queue_arn]
  }

  # CloudWatch Logs permissions
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.lambda.arn,
      "${aws_cloudwatch_log_group.lambda.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_sqs_logs" {
  name   = "${var.function_name}-lambda-sqs-logs-policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = data.aws_iam_policy_document.lambda_sqs_logs.json
}

# Create the Lambda function
resource "aws_lambda_function" "fifo_queue_nodejs_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "nodejs24.x"
  timeout          = 60
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = merge(var.tags, {
    Name = var.function_name
  })
}

# Connect the SQS Queue events to the Lambda
resource "aws_lambda_event_source_mapping" "fifo_queue_nodejs_lambda_mapping" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.fifo_queue_nodejs_lambda.arn
  batch_size       = 10

  depends_on = [aws_iam_role_policy.lambda_sqs_logs]
}
