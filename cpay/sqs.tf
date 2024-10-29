variable "payments_mutations_queue_max_receive_count" {
  description = "The maximum number of times a message can be received before being sent to the DLQ"
  default     = 1
}

variable "payments_mutations_queue_visibility_timeout" {
  description = "The visibility timeout for the queue"
  default     = 30 # AWS recommends the visibility timeout to be 6 times of the consumer timeout
}

variable "payments_mutations_queue_message_retention" {
  description = "The message retention period for the queue"
  default     = 345600 # 4 days
}

variable "payments_mutations_retry_dlq_message_retention" {
  description = "The message retention period for the retry DLQ"
  default     = 345600 # 4 days
}

variable "payments_mutations_dlq_message_retention" {
  description = "The message retention period for the DLQ"
  default     = 1209600 # 14 days
}

output "payments_mutations_queue_arn" {
  value = aws_sqs_queue.payments_mutations_queue.arn
}

output "payments_mutations_dlq_arn" {
  value = aws_sqs_queue.payments_mutations_dlq.arn
}

output "payments_mutations_retry_dlq_arn" {
  value = aws_sqs_queue.payments_mutations_retry_dlq.arn
}

output "payments_mutations_queue_url" {
  value = aws_sqs_queue.payments_mutations_queue.url
}

output "payments_mutations_dlq_url" {
  value = aws_sqs_queue.payments_mutations_dlq.url
}

output "payments_mutations_retry_dlq_url" {
  value = aws_sqs_queue.payments_mutations_retry_dlq.url
}

resource "aws_sqs_queue" "payments_mutations_queue" {
  name = "shopify-payments-mutations-queue-${terraform.workspace}"
  visibility_timeout_seconds = var.payments_mutations_queue_visibility_timeout
  message_retention_seconds = var.payments_mutations_queue_message_retention
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.payments_mutations_retry_dlq.arn
    maxReceiveCount     = var.payments_mutations_queue_max_receive_count
  })
}

resource "aws_sqs_queue" "payments_mutations_retry_dlq" {
  name = "shopify-payments-mutations-retry-dlq-${terraform.workspace}"
  message_retention_seconds = var.payments_mutations_retry_dlq_message_retention
}

resource "aws_sqs_queue" "payments_mutations_dlq" {
  name = "shopify-payments-mutations-dlq-${terraform.workspace}"
  message_retention_seconds = var.payments_mutations_dlq_message_retention
}
