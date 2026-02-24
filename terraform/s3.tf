resource "aws_s3_bucket" "secure_storage" {
  bucket = "zihao-cloud-storage-2026"

  tags = {
    Name        = "Secure Repository"
    Environment = "Dev"
    Project     = "CloudSecurity-Phase1"
  }
}

#Enable Versioning (Protects against accidental deletion)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Enforce SSE-KMS Encryption (Ensures data is encrypted at rest with AWS KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encryption" {
  bucket = aws_s3_bucket.secure_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
    # Reduces KMS costs and improves performance 
    bucket_key_enabled = true
  }
}

#Block All Public Access (Zero Trust approach to prevent data leaks)
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.secure_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#S3 Bucket Policy: IP Restriction with Root Account Exclusion
resource "aws_s3_bucket_policy" "zihao_ip_restriction" {
  bucket = aws_s3_bucket.secure_storage.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "IPRestrictionExcludingRoot",
        "Effect": "Deny",
        "NotPrincipal": {
          "AWS": "arn:aws:iam::065025975601:root"
        },
        "Action": "s3:*",
        "Resource": [
          "arn:aws:s3:::zihao-cloud-storage-2026",
          "arn:aws:s3:::zihao-cloud-storage-2026/*"
        ],
        "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": "109.175.195.178/32"
          }
        }
      }
    ]
  })
}
