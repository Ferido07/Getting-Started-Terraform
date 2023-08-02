# s3 bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "allow_elb_write_access_logs" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.allow_elb_write_access_logs.json
}

data "aws_iam_policy_document" "allow_elb_write_access_logs" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.elb_service_account_arn]
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

# IAM Role
resource "aws_iam_role" "ec2_read_s3_role" {
  name = "${var.bucket_name}-ec2_read_s3_role"

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

  tags = merge({ Name = "${var.bucket_name}-ec2_read_s3_role" }, var.tags)
}

# IAM role policy
resource "aws_iam_role_policy" "read_s3_policy" {
  name = "${var.bucket_name}-read_s3_policy"
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
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
    ]
  })
}

# ec2 instance profile
resource "aws_iam_instance_profile" "ec2_read_s3_profile" {
  name = "${var.bucket_name}-ec2_read_s3_profile"
  role = aws_iam_role.ec2_read_s3_role.name
  tags = merge({ Name = "${var.bucket_name}-ec2_read_s3_profile" }, var.tags)
}
