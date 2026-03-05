# Get AWS Account ID
data "aws_caller_identity" "current" {}



# Logging Bucket (Stores CloudTrail logs)
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "zihao-access-logs-2026"

  tags = {
    Name        = "CloudTrail Logs"
    Environment = "Dev"
    Project     = "CloudSecurity-Phase1"
  }
}



# Block Public Access for Logging Bucket
resource "aws_s3_bucket_public_access_block" "logging_public_block" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}




# Enable Versioning for Logging Bucket
resource "aws_s3_bucket_versioning" "logging_versioning" {
  bucket = aws_s3_bucket.logging_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}




# Allow CloudTrail to write logs to the Logging Bucket
resource "aws_s3_bucket_policy" "cloudtrail_logging_policy" {
  bucket = aws_s3_bucket.logging_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Sid = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logging_bucket.arn
      },

      {
        Sid = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.logging_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }

    ]
  })
}



# CloudTrail Audit Trail

resource "aws_cloudtrail" "s3_data_audit" {
  name                          = "zihao-s3-audit-trail"
  s3_bucket_name                = aws_s3_bucket.logging_bucket.id
  include_global_service_events = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"

      values = [
        "${aws_s3_bucket.secure_storage.arn}/"
      ]
    }
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_logging_policy
  ]
}