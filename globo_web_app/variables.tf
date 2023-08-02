variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_vpc_enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "subnet_count" {
  type    = number
  default = 2
}

variable "aws_subnet_map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "company" {
  type    = string
  default = "Globomantics"
}

variable "project" {
  type = string
}

variable "billing_code" {
  type = string
}

variable "naming_prefix" {
  type    = string
  default = "globo-web-app"
}