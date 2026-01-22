# Terraform Practice

This repository contains Terraform practice examples and implementations explaining the simple working of infrastructure as code (IaC) with Terraform.

## 📚 Overview

This project demonstrates various Terraform implementations for deploying and managing cloud infrastructure. Each implementation includes detailed documentation and working examples.

## 🗂️ Project Structure

```
Terraform-practice/
├── 1. Deploying Infrastructure/
│   ├── first_ec2.tf          # Terraform configuration for EC2 instance
│   └── first_ec2.md          # Detailed documentation
├── .gitignore                # Git ignore rules for Terraform files
└── README.md                 # This file
```

## 🚀 Implementations

### 1. Deploying Infrastructure - First EC2 Instance

This implementation demonstrates how to deploy a basic EC2 instance on AWS using Terraform.

**Configuration File:** `1. Deploying Infrastructure/first_ec2.tf`

**Key Components:**
- **Provider:** AWS provider configured for `us-east-1` region
- **Resource:** EC2 instance with:
  - AMI ID: `ami-00c39f71452c08778`
  - Instance Type: `t2.micro`
  - Tags: Name = "test-ec2"

**Usage:**

```bash
# Navigate to the implementation directory
cd "1. Deploying Infrastructure"

# Initialize Terraform (downloads providers)
terraform init

# Preview the changes
terraform plan

# Apply the configuration (creates the infrastructure)
terraform apply

# Destroy the infrastructure when done
terraform destroy
```

**Important Notes:**
- ⚠️ **Do NOT store AWS credentials directly in `.tf` files**
- Use environment variables or AWS credentials file instead:
  ```bash
  export AWS_ACCESS_KEY_ID="your-access-key"
  export AWS_SECRET_ACCESS_KEY="your-secret-key"
  ```
- Each EC2 instance has a unique AMI ID that differs by region
- The resource name `test-ec2` can be changed to any valid identifier

For detailed documentation, see: [`1. Deploying Infrastructure/first_ec2.md`](1.%20Deploying%20Infrastructure/first_ec2.md)

## 📖 Documentation References

- [Terraform Registry](https://registry.terraform.io/)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## 🔒 Security Best Practices

- Never commit credentials or sensitive data to version control
- Use environment variables or AWS IAM roles for authentication
- Review `.gitignore` to ensure sensitive files are excluded
- Use Terraform variables for configurable values

## 📝 Notes

- This repository will be updated with additional implementations and examples
- Each implementation includes its own detailed documentation
- All Terraform state files and sensitive data are excluded via `.gitignore`
