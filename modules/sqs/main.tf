resource "aws_sqs_queue" "fifo_queue" {
  name = "${var.queue_name}.fifo"

  fifo_queue                  = true
  content_based_deduplication = true
  delay_seconds               = 0
  max_message_size            = 1024
  message_retention_seconds   = 86400 # 1 day
  receive_wait_time_seconds   = 0
  sqs_managed_sse_enabled     = true
  visibility_timeout_seconds  = 360

  tags = merge(var.tags, {
    Name = var.queue_name
  })
}
