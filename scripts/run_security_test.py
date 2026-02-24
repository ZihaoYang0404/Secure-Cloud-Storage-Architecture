import boto3
from botocore.exceptions import ClientError
import os

def run_security_test():
    # Detect the current AWS Profile for professional logging
    current_profile = os.environ.get('AWS_PROFILE', 'default')
    s3 = boto3.client('s3', region_name='eu-west-2')
    bucket_name = 'zihao-cloud-storage-2026'
    file_content = f"Security test payload from profile: {current_profile}"
    file_name = "security_test.txt"

    print(f"--- Security Validation Logic ---")
    print(f"Current Identity: [{current_profile}]")
    print(f"Action: s3:PutObject")
    print(f"Target Bucket: {bucket_name}")
    print(f"---------------------------------")

    try:
        # Attempting the upload
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)
        
        # If successful, we check if this was expected
        if "admin" in current_profile.lower():
            print("✅ SUCCESS: Upload completed. (Expected for Admin role)")
            print("Status: INFRASTRUCTURE_READY")
        else:
            print("⚠️ WARNING: Upload succeeded. (Security Vulnerability: Permissions are too broad!)")
            print("Status: VULNERABLE")

    except ClientError as e:
        error_code = e.response['Error']['Code']
        
        if error_code == 'AccessDenied':
            if "analyst" in current_profile.lower() or "attacker" in current_profile.lower():
                print(f"✅ PASS: Access denied with code '{error_code}'.")
                print("Result: Least Privilege Principle (PoLP) successfully enforced.")
            else:
                print(f"❌ FAIL: Admin access was denied. Check your Bucket Policy IP whitelisting.")
        else:
            print(f"❗ UNKNOWN ERROR: {error_code}")

if __name__ == '__main__':
    run_security_test()