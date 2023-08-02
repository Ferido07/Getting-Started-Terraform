billing_code = "ACCT8675309"
project      = "globo-web-app"

aws_vpc_cidr = {
  dev  = "10.0.0.0/16"
  prod = "10.1.0.0/16"
}

subnet_count = {
  dev  = 2 # Atlease 2 are needed for load balancer 
  prod = 3
}

aws_instance_type = {
  dev  = "t2.micro"
  prod = "t2.micro"
}

instance_count = {
  dev  = 1
  prod = 2
}