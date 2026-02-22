output "endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.db.db_instance_endpoint
}

output "db_secret_arn" {
  description = "The ARN of the secret for the master user of the RDS instance"
  value       = module.db.db_instance_master_user_secret_arn
}
