data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnets[(count.index % var.subnet_count)].id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_s3_profile.name
  depends_on             = [aws_iam_role_policy.read_s3_policy]

  user_data = templatefile("${path.module}/launch-template.tpl", {
    s3_bucket_name = aws_s3_bucket.website_bucket.id
  })

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-ec2-${count.index + 1}" })
}
