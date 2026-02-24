# Threat Model: Secure S3 Storage Architecture

This threat model follows the **STRIDE** framework to identify potential security risks and document implemented mitigations.

| Category | Threat | Mitigation in Project |
| :--- | :--- | :--- |
| **Spoofing** | Unauthorized user gains access via leaked IAM keys. | **MFA** required for sensitive actions and **IP Whitelisting** enforced at the bucket level. |
| **Tampering** | Malicious actor modifies or deletes critical files. | Enabled **S3 Versioning** to allow recovery and used **Least-Privilege** IAM policies. |
| **Repudiation** | An attacker deletes logs to hide their tracks. | Configured **AWS CloudTrail** to log all S3 management events to a separate audit trail. |
| **Information Disclosure** | Sensitive data leaked due to a misconfigured public bucket. | Enabled **S3 Block Public Access** and enforced **SSE-KMS Encryption** at rest. |
| **Denial of Service** | Massive number of requests leading to high KMS costs. | Enabled **S3 Bucket Keys** to reduce KMS request traffic and associated costs. |
| **Elevation of Privilege** | IAM user bypasses restrictions to gain full admin access. | Implemented **Explicit Deny** in Bucket Policy; even Root is restricted by the network perimeter. |