# Bucket name
variable "bucket_name" {
  type        = string
  description = "The name of the bucket"
}

# ELB Service Account for Load Balancer logs
variable "elb_service_account_arn" {
  type        = string
  description = "The ARN of the ELB service account"
}

# Tags
variable "tags" {
  type        = map(string)
  description = "Tags to add to bucket and resources"
  default     = {}
}