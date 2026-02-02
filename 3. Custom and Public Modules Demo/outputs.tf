# -----------------------------------------------------------------------------
# Root module outputs - from custom module and public module
# -----------------------------------------------------------------------------

# Custom EC2 module outputs
output "custom_ec2_instance_id" {
  description = "Instance ID from the custom EC2 module"
  value       = module.custom_ec2.instance_id
}

output "custom_ec2_public_ip" {
  description = "Public IP from the custom EC2 module"
  value       = module.custom_ec2.public_ip
}

# Public S3 bucket module outputs
output "s3_bucket_id" {
  description = "S3 bucket ID from the public module"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN from the public module"
  value       = module.s3_bucket.s3_bucket_arn
}
