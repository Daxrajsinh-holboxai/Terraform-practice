# -----------------------------------------------------------------------------
# Root module variable declarations - set values in terraform.tfvars
# Copy terraform.tfvars.example to terraform.tfvars and fill in.
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key for provider authentication"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for provider authentication"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment label for naming and tagging"
  type        = string
  default     = "demo"
}

# Custom EC2 module inputs
variable "custom_ec2_name_prefix" {
  description = "Name prefix for resources created by the custom EC2 module"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the custom EC2 instance (region-specific)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the custom module"
  type        = string
  default     = "t2.micro"
}

# Public S3 module inputs
variable "s3_bucket_name_prefix" {
  description = "Prefix for the S3 bucket name (public module); bucket name will be prefix-env-timestamp"
  type        = string
}
