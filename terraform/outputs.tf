# --- OUTPUTS ---
# Outputs to display after Terraform apply, providing key information about the created resources.

output "storage_bucket_name" {
  description = "The name of the secure storage bucket"
  value       = aws_s3_bucket.secure_storage.id
}


output "storage_bucket_arn" {
  description = "The ARN of the secure storage bucket"
  value       = aws_s3_bucket.secure_storage.arn
}


output "test_users" {
  description = "List of IAM users created for security testing"
  value       = [
    aws_iam_user.admin_user.name,
    aws_iam_user.analyst_user.name,
    aws_iam_user.outsider_user.name
  ]
}


output "logging_bucket_name" {
  description = "The name of the bucket storing CloudTrail logs"
  value       = aws_s3_bucket.logging_bucket.id
}


output "cloudtrail_id" {
  description = "The ID of the CloudTrail for auditing"
  value       = aws_cloudtrail.s3_data_audit.id
}