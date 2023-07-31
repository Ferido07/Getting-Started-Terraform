# s3 bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true
  tags          = merge(local.common_tags, { Name = "${local.naming_prefix}-bucket" })
}

resource "aws_s3_bucket_policy" "allow_elb_write_access_logs" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.allow_elb_write_access_logs.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "allow_elb_write_access_logs" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      # aws_s3_bucket.website_bucket.arn
      "${aws_s3_bucket.website_bucket.arn}/lb-logs/*",
    ]
  }
}

# s3 bucket objects
resource "aws_s3_object" "website" {
  for_each = {
    index = "website/index.html"
    logo  = "website/Globo_logo_Vert.png"
  }
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.value
  source = each.value
  etag   = filemd5(each.value)
  tags   = merge(local.common_tags, { Name = "${local.naming_prefix}-website-resource" })
}

# IAM Role
resource "aws_iam_role" "ec2_read_s3_role" {
  name = "${local.naming_prefix}-ec2_read_s3_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-ec2_read_s3_role" })
}

# IAM role policy
resource "aws_iam_role_policy" "read_s3_policy" {
  name = "${local.naming_prefix}-read_s3_policy"
  role = aws_iam_role.ec2_read_s3_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      },
    ]
  })
}

# ec2 instance profile
resource "aws_iam_instance_profile" "ec2_read_s3_profile" {
  name = "${local.naming_prefix}-ec2_read_s3_profile"
  role = aws_iam_role.ec2_read_s3_role.name
  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-ec2_read_s3_profile" })
}
