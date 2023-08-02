data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count[terraform.workspace]
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_type[terraform.workspace]
  subnet_id              = module.vpc.public_subnets[(count.index % var.subnet_count[terraform.workspace])]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = module.s3.instance_profile.name
  depends_on             = [module.s3]

  user_data = templatefile("${path.module}/launch-template.tpl", {
    s3_bucket_name = module.s3.bucket.id
  })

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-ec2-${count.index + 1}" })
}
