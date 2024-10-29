variable "email_topic_subscription" {
  type        = list(string)
  description = "Email addresses to send notifications to"
}

resource "aws_sns_topic" "sns_topic" {
  name = "curacao-aws-alarms-${terraform.workspace}"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count     = length(var.email_topic_subscription)
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.email_topic_subscription[count.index]
}

# CloudWatch Metric Filter
resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name          = "Payments-DLQ-Alarm-${terraform.workspace}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Triggered when a message is placed in the DLQ"
  alarm_actions       = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    QueueName = aws_sqs_queue.payments_mutations_dlq.name
  }

  tags = {
    Environment = terraform.workspace
  }
}
