resource "aws_lb" "nginx_lb" {
  name               = "${local.naming_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = module.vpc.public_subnets

  access_logs {
    bucket  = module.s3.bucket.id
    prefix  = "lb-logs"
    enabled = true
  }

  enable_deletion_protection = false

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-lb" })
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = "${local.naming_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-tg" })
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-listener" })
}

resource "aws_lb_target_group_attachment" "tg" {
  count            = var.instance_count[terraform.workspace]
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}
