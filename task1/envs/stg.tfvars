vpc_cidr               = "10.1.0.0/16"
public_subnets_cidrs   = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets_cidrs  = ["10.1.101.0/24", "10.1.102.0/24"]
database_subnets_cidrs = ["10.1.201.0/24", "10.1.202.0/24"]
instance_type          = "t3.small"
db_instance_class      = "db.t3.micro"
