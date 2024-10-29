data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

output "github_actions_iam_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role       = aws_iam_role.cloudwatch.name
}

resource "aws_iam_role" "github_actions_role" {
  name = "github_actions_${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:meetdomaine/curacao-offsite-payments-app:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "serverless_deploy_policy" {
  name = "serverless_deploy_${terraform.workspace}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["lambda:*"]
        Resource = [
          "arn:aws:lambda:${local.region}:*:function:curacao-payments-webhooks-${terraform.workspace}-*",
          "arn:aws:lambda:${local.region}:*:function:curacao-api-${terraform.workspace}-*",
          "arn:aws:lambda:${local.region}:*:function:curacao-admin-app-${terraform.workspace}-*",
          "arn:aws:lambda:${local.region}:*:function:curacao-payments-api-${terraform.workspace}-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "apigateway:*"
        ]
        Resource = [
          module.payments_api_gateway.api_gateway_arn,
          module.admin_app_gateway.api_gateway_arn,
          module.api_gateway.api_gateway_arn
        ]
      },
      {
        Effect = "Allow"
        Action = ["s3:*"]
        Resource = [
          "arn:aws:s3:::curacao-shopify-tf-state",
          "arn:aws:s3:::curacao-shopify-tf-state/*",
          aws_s3_bucket.admin_app_web_bucket.arn,
          "${aws_s3_bucket.admin_app_web_bucket.arn}/*",
          "arn:aws:s3:::*serverless*",
          "arn:aws:s3:::*serverless*/*",
          "arn:aws:s3:::serverless-framework-state-*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListAllMyBuckets"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups"
        ]
        Resource = "arn:aws:logs:${local.region}:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRole"
        ]
        Resource = [
          "arn:aws:iam::*:role/curacao-*",
          "arn:aws:iam::*:role/serverless-*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::*:role/curacao-*"
        Condition = {
          StringEquals = {
            "iam:PassedToService" = [
              "lambda.amazonaws.com",
              "apigateway.amazonaws.com"
            ]
          }
        }
      },
      {
        Effect = "Allow"
        Action = ["cloudformation:*"]
        Resource = [
          "arn:aws:cloudformation:${local.region}:${local.account_id}:stack/curacao-admin-app-${terraform.workspace}/*",
          "arn:aws:cloudformation:${local.region}:${local.account_id}:stack/curacao-api-${terraform.workspace}/*",
          "arn:aws:cloudformation:${local.region}:${local.account_id}:stack/curacao-payments-webhooks-${terraform.workspace}/*",
          "arn:aws:cloudformation:${local.region}:${local.account_id}:stack/curacao-payments-api-${terraform.workspace}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "cloudformation:ValidateTemplate"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = [
          "arn:aws:ssm:us-east-1:${local.account_id}:parameter/serverless-framework/*",
          "arn:aws:ssm:${local.region}:${local.account_id}:parameter/serverless-framework/deployment/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "serverless_deploy_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.serverless_deploy_policy.arn
}
