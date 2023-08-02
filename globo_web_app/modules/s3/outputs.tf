output "bucket" {
  value       = aws_s3_bucket.website_bucket
  description = "The created bucket"
}

output "instance_profile" {
  value       = aws_iam_instance_profile.ec2_read_s3_profile
  description = "The instance profile to attach to instances to allow downloading content from the bucket"
}