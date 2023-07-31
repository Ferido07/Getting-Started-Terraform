locals {
  common_tags = {
    company      = var.company
    billing_code = var.billing_code
    project      = "${var.company}-${var.project}"
    Terraform    = true
  }
  naming_prefix  = "dev-${var.naming_prefix}"
  s3_bucket_name = lower("${local.naming_prefix}-${random_integer.rand.result}")
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
