output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "The list of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The list of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "database_subnet_group_name" {
  description = "The name of the database subnet group"
  value       = module.vpc.database_subnet_group_name
}


output "instance_sg_id" {
  description = "The ID of the EC2 instance security group"
  value       = module.instance_sg.security_group_id
}
output "db_sg_id" {
  description = "The ID of the RDS security group"
  value       = module.db_sg.security_group_id
}
