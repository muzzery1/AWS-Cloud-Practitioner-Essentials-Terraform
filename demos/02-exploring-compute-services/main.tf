# Data
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

# Modules
module "sqs" {
  source = "../../modules/sqs"

  queue_name = "${local.demo_name}-queue"
  tags       = local.default_tags
}

module "lambda" {
  source = "../../modules/lambda"

  function_name = "${local.demo_name}-lambda"
  source_dir    = "../../demos/02-exploring-compute-services/lambda"
  tags          = local.default_tags
  sqs_queue_arn = module.sqs.queue_arn
}