data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${local.naming_prefix}-vpc"
  cidr = var.aws_vpc_cidr[terraform.workspace]

  azs            = slice(data.aws_availability_zones.available.names, 0, var.subnet_count[terraform.workspace])
  public_subnets = [for i in range(var.subnet_count[terraform.workspace]) : cidrsubnet(var.aws_vpc_cidr[terraform.workspace], 8, i)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_dns_hostnames    = var.aws_vpc_enable_dns_hostnames
  map_public_ip_on_launch = var.aws_subnet_map_public_ip_on_launch

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-vpc" })
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "${local.naming_prefix}-ec2-sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.aws_vpc_cidr[terraform.workspace]]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-ec2-sg" })
}

# Load Balancer security group 
resource "aws_security_group" "lb_sg" {
  name   = "${local.naming_prefix}-lb-sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-lb-sg" })
}

