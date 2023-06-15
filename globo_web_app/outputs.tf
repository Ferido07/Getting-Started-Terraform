output "public_dns_hostname" {
  value = aws_instance.nginx1.public_dns
}