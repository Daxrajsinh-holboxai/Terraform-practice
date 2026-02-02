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
├── 2. Local-exec and Remote-exec Demo/
│   ├── variables.tf              # Variable declarations
│   ├── terraform.tfvars.example  # Example values (copy to terraform.tfvars)
│   ├── local_remote_exec.tf      # Provider, resources, provisioners
│   └── local_remote_exec.md      # Detailed documentation
├── 3. Custom and Public Modules Demo/
│   ├── variables.tf              # Root variable declarations
│   ├── terraform.tfvars.example  # Example values (copy to terraform.tfvars)
│   ├── main.tf                   # Provider, custom + public module calls
│   ├── outputs.tf                # Root outputs from both modules
│   ├── modules/custom-ec2/       # Custom local module (EC2 + security group)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── custom_public_modules.md  # Detailed documentation
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

### 2. Local-exec and Remote-exec Demo

This implementation demonstrates Terraform **local-exec** and **remote-exec** provisioners on an EC2 instance.

**Configuration File:** `2. Local-exec and Remote-exec Demo/local_remote_exec.tf`

**What it does:**
- **local-exec** – Runs on your machine after the instance is created and stores the EC2 public IP in `ec2_ip.txt`.
- **remote-exec** – Runs on the EC2 instance over SSH and performs a basic task: writes `Working` to `/tmp/remote_exec_demo.txt`.

**Architecture:**
- **variables.tf** – Variable declarations.
- **terraform.tfvars.example** – Example values; copy to `terraform.tfvars` and set your credentials (tfvars is in .gitignore).
- **local_remote_exec.tf** – Provider, data sources, EC2, and provisioners.

**Key components:**
- TLS key pair and AWS key pair for SSH.
- Security group allowing SSH (port 22).
- EC2 instance with both provisioners and outputs for IP and file paths.

**Usage:**

```bash
cd "2. Local-exec and Remote-exec Demo"

# Set variable values (terraform.tfvars is auto-loaded, not committed)
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with aws_access_key, aws_secret_key, etc.

terraform init
terraform plan
terraform apply
```

**After apply:**
- Check `ec2_ip.txt` in the same folder for the EC2 public IP.
- Verify remote-exec: `ssh -i demo_key.pem ec2-user@<PUBLIC_IP> "cat /tmp/remote_exec_demo.txt"` → should show `Working`.

For detailed documentation, see: [`2. Local-exec and Remote-exec Demo/local_remote_exec.md`](2.%20Local-exec%20and%20Remote-exec%20Demo/local_remote_exec.md)

### 3. Custom and Public Modules Demo

This implementation shows how to use a **custom local module** and a **public module** from the Terraform Registry.

**Configuration:** `3. Custom and Public Modules Demo/`

**What it does:**
- **Custom module** (`./modules/custom-ec2`) – Local module that creates one EC2 instance in the default VPC with a security group (SSH). Has its own `variables.tf`, `main.tf`, and `outputs.tf`.
- **Public module** – Uses `terraform-aws-modules/s3-bucket/aws` from the Registry (version `~> 4.0`) to create an S3 bucket.

**Architecture (same as folder 2):**
- **variables.tf** – Root variable declarations.
- **terraform.tfvars.example** – Example values; copy to `terraform.tfvars` and set credentials and a unique S3 bucket prefix.
- **main.tf** – Provider, `module "custom_ec2"` (source `./modules/custom-ec2`), and `module "s3_bucket"` (source from Registry).
- **outputs.tf** – Root outputs from both modules.
- **modules/custom-ec2/** – Custom module (EC2 + SG).

**Usage:**

```bash
cd "3. Custom and Public Modules Demo"

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: aws_access_key, aws_secret_key, s3_bucket_name_prefix (globally unique)

terraform init   # Downloads public module
terraform plan
terraform apply
```

**Notes:**
- S3 bucket names must be globally unique; set `s3_bucket_name_prefix` to something unique in `terraform.tfvars`.
- Custom module is under `modules/custom-ec2`; public module is pulled from the Registry on `terraform init`.

For detailed documentation, see: [`3. Custom and Public Modules Demo/custom_public_modules.md`](3.%20Custom%20and%20Public%20Modules%20Demo/custom_public_modules.md)

## 📖 Documentation References

- [Terraform Registry](https://registry.terraform.io/)
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [terraform-aws-modules/s3-bucket/aws](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws)

## 🔒 Security Best Practices

- Never commit credentials or sensitive data to version control
- Use environment variables or AWS IAM roles for authentication
- Review `.gitignore` to ensure sensitive files are excluded
- Use Terraform variables for configurable values

## 📝 Notes

- This repository will be updated with additional implementations and examples
- Each implementation includes its own detailed documentation
- All Terraform state files and sensitive data are excluded via `.gitignore`
