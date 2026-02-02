### Documentation Referred

- [Terraform Registry](https://registry.terraform.io/)
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)
- [terraform-aws-modules/s3-bucket/aws](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws)

### File layout (same structure as folder 2)

- **variables.tf** – Variable declarations for the root module.
- **terraform.tfvars.example** – Example values; copy to `terraform.tfvars` and fill in.
- **main.tf** – Provider, custom module call, and public module call.
- **outputs.tf** – Root outputs from both modules.
- **modules/custom-ec2/** – Custom local module (EC2 + security group).

### What this demo does

1. **Custom module** (`./modules/custom-ec2`)
   - Local module in this repo.
   - Creates one EC2 instance in the default VPC with a security group (SSH allowed).
   - Inputs: `name_prefix`, `ami_id`, `instance_type`, `environment`.
   - Outputs: `instance_id`, `public_ip`, `security_group_id`.

2. **Public module** (`terraform-aws-modules/s3-bucket/aws`)
   - Module from the Terraform Registry.
   - Creates an S3 bucket with standard options.
   - Used with a version constraint (`~> 4.0`).
   - Root module passes `bucket` name and `tags`.

### Custom module structure

```
modules/custom-ec2/
├── main.tf      # Data sources, security group, EC2 instance
├── variables.tf # Input variables
└── outputs.tf   # instance_id, public_ip, security_group_id
```

### Root module (this folder)

- **main.tf** – Calls:
  - `module "custom_ec2" { source = "./modules/custom-ec2" ... }`
  - `module "s3_bucket" { source = "terraform-aws-modules/s3-bucket/aws" version = "~> 4.0" ... }`
- **variables.tf** – Root variables (AWS, custom EC2 inputs, S3 bucket prefix).
- **outputs.tf** – Forwards custom EC2 and S3 bucket outputs.

### Commands

```sh
# Copy example tfvars and set your values (S3 bucket name must be globally unique)
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: aws_access_key, aws_secret_key, s3_bucket_name_prefix (unique)

terraform init   # Downloads public module and initializes backend
terraform plan
terraform apply
```

### Notes

- **Custom module**: Reusable EC2 + SG in `./modules/custom-ec2`; change it by editing files under that path.
- **Public module**: S3 bucket from Registry; upgrade by changing `version` in `main.tf`.
- **S3 bucket name**: Must be globally unique; set `s3_bucket_name_prefix` in `terraform.tfvars` to something unique (e.g. include your name or a random suffix).
- `terraform.tfvars` is in `.gitignore`; do not commit credentials.
