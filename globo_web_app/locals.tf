locals {
  common_tags = {
    Name         = "Terraform Practice"
    company      = var.company
    billing_code = var.billing_code
    project      = "${var.company}-${var.project}"
  }
  s3_bucket_name = "globo-web-app-${random_integer.rand.result}"
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
