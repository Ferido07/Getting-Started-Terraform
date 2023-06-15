locals {
  common_tags = {
    Name = "Terraform Practice"
    company = var.company
    billing_code = var.billing_code
    project = "${var.company}-${var.project}"
  }
}