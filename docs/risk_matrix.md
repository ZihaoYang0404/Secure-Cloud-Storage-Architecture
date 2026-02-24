# Risk Assessment Matrix

This matrix evaluates the residual risk after implementing our security controls.

| Risk ID | Risk Description | Likelihood | Impact | Mitigation Strategy | Residual Risk |
| :--- | :--- | :--- | :--- | :--- | :--- |
| R1 | Compromised IAM User Credentials | Medium | High | Enforce **IP-based Access Control** and **MFA**. | **Low** |
| R2 | Misconfigured S3 Permissions | Low | High | Use **Infrastructure as Code (Terraform)** to ensure consistent, peer-reviewed configs. | **Low** |
| R3 | Data Loss due to Accidental Deletion | Medium | Medium | Enable **Versioning** and **MFA Delete**. | **Low** |
| R4 | Insider Threat (Unauthorized Access) | Low | High | Implement **IAM Access Analyzer** and regular audit log reviews. | **Medium** |

**Note:** "Low" residual risk for R1 is achieved because even if keys are leaked, the attacker cannot access the data from an unauthorized IP.