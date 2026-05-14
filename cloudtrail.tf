# Bucket dédié aux logs CloudTrail
resource "aws_s3_bucket" "logs_cloudtrail" {
  bucket = "agricam-cloudtrail-logs-${var.environnement}"
  tags   = { Projet = "AgriCam", Type = "Logs" }
}

resource "aws_s3_bucket_public_access_block" "logs_cloudtrail" {
  bucket                  = aws_s3_bucket.logs_cloudtrail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Politique S3 obligatoire pour que CloudTrail puisse écrire ses logs
resource "aws_s3_bucket_policy" "logs_cloudtrail" {
  bucket = aws_s3_bucket.logs_cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logs_cloudtrail.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs_cloudtrail.arn}/AWSLogs/${var.account_id}/*"
        Condition = {
          StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
        }
      }
    ]
  })
}

# CloudTrail — audit multi-région de toutes les actions
resource "aws_cloudtrail" "agricam_audit" {
  name                          = "agricam-trail-${var.environnement}"
  s3_bucket_name                = aws_s3_bucket.logs_cloudtrail.id
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true

  tags = { Projet = "AgriCam", Type = "Securite" }

  depends_on = [aws_s3_bucket_policy.logs_cloudtrail]
}
