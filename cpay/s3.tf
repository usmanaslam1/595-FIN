output "admin_app_web_bucket" {
  value = aws_s3_bucket.admin_app_web_bucket.id
}

resource "aws_s3_bucket" "admin_app_web_bucket" {
  bucket = "${terraform.workspace}-curacao-admin-app-web"
}

resource "aws_s3_bucket_public_access_block" "admin_app_web_bucket" {
  bucket = aws_s3_bucket.admin_app_web_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.admin_app_web_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.admin_app_web_oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "admin_app_web_bucket_policy" {
  bucket = aws_s3_bucket.admin_app_web_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
