locals {
  common_tags = {
    company      = var.company
    billing_code = var.billing_code
    project      = "${var.company}-${var.project}"
    terraform    = true
    environment  = terraform.workspace
  }
  naming_prefix  = "${terraform.workspace}-${var.naming_prefix}"
  s3_bucket_name = lower("${local.naming_prefix}-${random_integer.rand.result}")
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
