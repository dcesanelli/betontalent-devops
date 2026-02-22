vpc_cidr               = "10.5.0.0/16"
public_subnets_cidrs   = ["10.5.1.0/24", "10.5.2.0/24"]
private_subnets_cidrs  = ["10.5.101.0/24", "10.5.102.0/24"]
database_subnets_cidrs = ["10.5.201.0/24", "10.5.202.0/24"]

# Using small instance types to fit within free tier limits, 
# but these can be adjusted as needed.
instance_type = "t3.small"
