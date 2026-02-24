import boto3
from botocore.exceptions import NoCredentialsError, ClientError

def list_s3_buckets():
    """
    Connects to AWS S3 and lists all buckets in the account.
    """
    # Create an S3 client using the credentials configured in 'aws configure'
    s3 = boto3.client('s3')

    try:
        print("Connecting to AWS S3...")
        response = s3.list_buckets()
        
        print("\nSuccess! Here are your S3 buckets:")
        buckets = response.get('Buckets', [])
        
        if not buckets:
            print("No buckets found. Your cloud storage is currently empty.")
        else:
            for bucket in buckets:
                print(f"Bucket Name: {bucket['Name']}")
                
    except NoCredentialsError:
        print("Error: AWS credentials not found. Please run 'aws configure'.")
    except ClientError as e:
        print(f"Error connecting to AWS: {e}")

if __name__ == "__main__":
    list_s3_buckets()