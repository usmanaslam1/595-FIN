resource "aws_cloudwatch_log_group" "vpc-flow-logs" {
  name              = "vpc-flow-logs"
  retention_in_days = var.log_retention_in_days
  tags = {
    Name   = "595 - VPC Flow Logs"
    Author = var.author
    Team   = var.team
  }
}

resource "aws_cloudwatch_log_group" "rds-logs" {
  name              = "rds-mariadb-logs"
  retention_in_days = var.log_retention_in_days
  tags = {
    Name   = "595 - Amazon RDS  Maria DB logs"
    Author = var.author
    Team   = var.team
  }
}
resource "aws_cloudwatch_log_group" "ec2-logs" {
  name              = "ec2-logs"
  retention_in_days = var.log_retention_in_days
  tags = {
    Name   = "595 - Amazon EC2 logs"
    Author = var.author
    Team   = var.team
  }
}
