# s3 bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true
  tags          = local.common_tags
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
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "website/index.html"
  source = "website/index.html"
  etag   = filemd5("website/index.html")
  tags   = local.common_tags
}
resource "aws_s3_object" "logo" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "website/Globo_logo_Vert.png"
  source = "website/Globo_logo_Vert.png"
  etag   = filemd5("website/Globo_logo_Vert.png")
  tags   = local.common_tags
}

# IAM Role
resource "aws_iam_role" "ec2_read_s3_role" {
  name = "ec2_read_s3_role"

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

  tags = local.common_tags
}

# IAM role policy
resource "aws_iam_role_policy" "read_s3_policy" {
  name = "read_s3_policy"
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
  name = "ec2_read_s3_profile"
  role = aws_iam_role.ec2_read_s3_role.name
  tags = local.common_tags
}
