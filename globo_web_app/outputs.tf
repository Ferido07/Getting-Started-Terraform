output "public_dns_hostname" {
  value = aws_lb.nginx_lb.dns_name
}