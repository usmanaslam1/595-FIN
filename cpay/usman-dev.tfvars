project_name = "curacao-shopify"

# subnet
vpc_cidr_block              = "10.4.0.0/16"
public_subnet_cidr_block    = "10.4.1.0/24"
private_subnet_a_cidr_block = "10.4.2.0/24"
private_subnet_b_cidr_block = "10.4.3.0/24"

# route53 domain name
domain_name = "cpayosp.com"
zone_id     = "Z080547929X8A2UISMFMQ"

# cloudwatch - email_topic_subscription is a list, so you can add multiple emails
email_topic_subscription = ["uaslam@icuracao.com"]

# apigateway - MTLS configuration for payments API
payments_api_truststore_uri = "s3://curacao-shopify-tf-state/truststore/shopify-payments-certificates.pem"
payments_api_enable_mtls    = true

# sqs
payments_mutations_queue_max_receive_count = 1
payments_mutations_queue_visibility_timeout = 30
payments_mutations_queue_message_retention = 345600 # 4 days
payments_mutations_retry_dlq_message_retention = 345600 # 4 days
payments_mutations_dlq_message_retention = 1209600 # 14 days

