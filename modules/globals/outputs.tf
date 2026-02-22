# Global outputs for Task 1
output "env" {
  description = "Current environment (workspace) being deployed."
  value       = local.environment
}

output "global_tags" {
  description = "Global tags applied to all resources in this environment."
  value       = local.global_tags
}

output "project_prefix" {
  description = "Project prefix used for naming resources."
  value       = var.project_prefix
}

output "name_prefix" {
  description = "Prefix used for naming resources in this environment."
  value       = local.name_prefix
}

output "region" {
  description = "AWS region where resources are deployed."
  value       = var.region
}
