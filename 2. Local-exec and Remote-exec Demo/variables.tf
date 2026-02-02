# -----------------------------------------------------------------------------
# Variable declarations - define values in terraform.tfvars (or -var / env)
# Copy terraform.tfvars.example to terraform.tfvars and fill in your values.
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

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (region-specific)"
  type        = string
}

variable "environment" {
  description = "Environment label for naming/tagging"
  type        = string
  default     = "demo"
}
