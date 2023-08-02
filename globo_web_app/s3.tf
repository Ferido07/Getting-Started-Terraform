data "aws_elb_service_account" "main" {}

# s3 bucket
module "s3" {
  source                  = "./modules/s3"
  bucket_name             = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.main.arn
  tags                    = merge(local.common_tags, { Name = "${local.naming_prefix}-bucket" })
}

# s3 bucket objects
resource "aws_s3_object" "website" {
  for_each = {
    index = "website/index.html"
    logo  = "website/Globo_logo_Vert.png"
  }
  bucket = module.s3.bucket.bucket
  key    = each.value
  source = each.value
  etag   = filemd5(each.value)
  tags   = merge(local.common_tags, { Name = "${local.naming_prefix}-website-resource" })
}
