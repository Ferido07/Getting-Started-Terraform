variable "aws_access_key" {
  type = string
  sensitive = true
}

variable "aws_secret_key" {
  type = string
  sensitive = true
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "aws_vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "aws_vpc_enable_dns_hostnames" {
  type = bool
  default = true
}

variable "aws_subnet_cidr_block" {
  type = string
  default = "10.0.0.0/24"
}

variable "aws_subnet_map_public_ip_on_launch" {
  type = bool
  default = true
}

variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}


variable "company" {
  type = string
  default = "Globomantics"
}

variable "project" {
  type = string
}

variable "billing_code" {
  type = string
}