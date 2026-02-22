output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "ec2_public_ip" {
  description = "Public IP of the App Server"
  value       = module.compute.public_ip
}

output "ec2_dns_name" {
  description = "Public DNS of the App Server"
  value       = module.compute.public_dns
}

output "rds_endpoint" {
  description = "RDS Connection Endpoint"
  value       = module.database.endpoint
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS password"
  value       = module.database.db_secret_arn
}
