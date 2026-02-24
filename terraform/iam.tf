#IAM USERS FOR PERMISSION TESTING

# User: Admin 
resource "aws_iam_user" "admin_user" {
  name = "Zihao-Admin"
}
resource "aws_iam_user_policy_attachment" "admin_s3" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "admin_kms" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:policy/AWSKeyManagementServicePowerUser"
}

resource "aws_iam_user_policy_attachment" "admin_cloudtrail" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:policy/CloudTrailReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "admin_change_password" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:policy/IAMUserChangePassword"
}


# User: Analyst (Least Privilege)
resource "aws_iam_user" "analyst_user" {
  name = "zihao-security-analyst"
}
resource "aws_iam_policy" "analyst_policy" {
  name   = "LeastPrivilegeDataAnalystPolicy"
  policy = file("${path.module}/../iam_policies/LeastPrivilegeDataAnalystPolicy.json")
}
resource "aws_iam_user_policy_attachment" "analyst_attach" {
  user       = aws_iam_user.analyst_user.name
  policy_arn = aws_iam_policy.analyst_policy.arn
}


# User: Outsider (Simulated Attacker)
resource "aws_iam_user" "outsider_user" {
  name = "zihao-external-attacker"
}