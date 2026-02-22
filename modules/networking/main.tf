# Create VPC and related networking resources for the project.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.6"

  name = "${var.globals.name_prefix}-vpc"
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  public_subnets   = var.public_subnets_cidrs
  private_subnets  = var.private_subnets_cidrs
  database_subnets = var.database_subnets_cidrs

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false
  single_nat_gateway = false

  tags = merge(var.globals.global_tags, {
    Name = "VPC"
  })
}

# Create a security group for the EC2 instance
module "instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.globals.name_prefix}-sg"
  description = "Allow SSH traffic"
  vpc_id      = module.vpc.vpc_id

  # Restrict all ingress traffic, when we define what we want to allow, we will add those rules explicitly.
  ingress_rules = []
  egress_rules  = ["all-all"]

  tags = merge(var.globals.global_tags, {
    Name = "EC2 Instance Security Group"
  })
}

# Create a security group for the RDS instance and allow traffic from the EC2 instance security group
module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.globals.name_prefix}-db-sg"
  description = "Allow Database traffic from EC2 instance SG"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.instance_sg.security_group_id
    }
  ]

  tags = merge(var.globals.global_tags, {
    Name = "Database Security Group"
  })
}
