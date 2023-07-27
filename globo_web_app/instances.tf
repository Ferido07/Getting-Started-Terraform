data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_s3_profile.name
  depends_on             = [aws_iam_role_policy.read_s3_policy]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/website/index.html /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/website/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
EOF

  tags = local.common_tags
}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_s3_profile.name
  depends_on             = [aws_iam_role_policy.read_s3_policy]

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/website/index.html /usr/share/nginx/html/index.html
sudo aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/website/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
EOF

  tags = local.common_tags
}

