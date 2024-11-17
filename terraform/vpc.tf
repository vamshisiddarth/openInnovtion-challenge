data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  name                 = "challenge"
  cidr                 = "10.16.0.0/16" # 131070
  azs                  = data.aws_availability_zones.available.names

  create_database_subnet_group = true

  public_subnets = [
    "10.16.96.0/19",  # 8190
    "10.16.128.0/19", # 8190
    "10.16.160.0/19"  # 8190
  ]

  private_subnets = [
    "10.16.0.0/19",  # 8190
    "10.16.32.0/19", # 8190
    "10.16.64.0/19"  # 8190
  ]

  database_subnets = [
    "10.16.192.0/19", # 8190
    "10.16.224.0/20", # 4094
    "10.16.240.0/20"  # 4094
  ]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    terraform   = "true"
    environment = "challenge"
    name        = "challenge"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    terraform   = "true"
    environment = "challenge"
    name        = "challenge"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    terraform   = "true"
    environment = "challenge"
    name        = "challenge"
  }
}