vpc_cidr               = "10.2.0.0/16"
public_subnets_cidrs   = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnets_cidrs  = ["10.2.101.0/24", "10.2.102.0/24"]
database_subnets_cidrs = ["10.2.201.0/24", "10.2.202.0/24"]

# Using small and micro instance types to fit within free tier limits, 
# but these can be adjusted as needed.
instance_type     = "t3.small"
db_instance_class = "db.t3.micro"
