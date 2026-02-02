# -----------------------------------------------------------------------------
# Custom and Public Modules Demo
# - Custom module: ./modules/custom-ec2 (creates one EC2 + security group)
# - Public module: terraform-aws-modules/s3-bucket/aws (from Terraform Registry)
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# -----------------------------------------------------------------------------
# Custom module - local module in ./modules/custom-ec2
# -----------------------------------------------------------------------------

module "custom_ec2" {
  source = "./modules/custom-ec2"

  name_prefix    = var.custom_ec2_name_prefix
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  environment    = var.environment
}

# -----------------------------------------------------------------------------
# Public module - from Terraform Registry
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws
# -----------------------------------------------------------------------------

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "${var.s3_bucket_name_prefix}-${var.environment}"

  tags = {
    Name        = "${var.s3_bucket_name_prefix}-${var.environment}"
    Environment = var.environment
  }
}
