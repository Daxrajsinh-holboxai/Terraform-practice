# -----------------------------------------------------------------------------
# Custom EC2 module - variable declarations
# -----------------------------------------------------------------------------

variable "name_prefix" {
  description = "Prefix for resource names (e.g., custom-demo)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (region-specific)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment label for tagging"
  type        = string
  default     = "demo"
}
