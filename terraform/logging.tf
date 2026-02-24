#LOGGING INFRASTRUCTURE (The Evidence Collector)
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "zihao-access-logs-2026"
}

#CLOUDTRAIL FOR AUDIT LOGS
resource "aws_cloudtrail" "s3_data_audit" {
  name                          = "zihao-s3-audit-trail"
  s3_bucket_name                = aws_s3_bucket.logging_bucket.id
  include_global_service_events = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.secure_storage.arn}/"]
    }
  }
}