output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "ec2_private_ip" {
  description = "Private IP of the App Server"
  value       = module.compute.private_ip
}
