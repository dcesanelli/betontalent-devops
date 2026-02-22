output "public_ip" {
  description = "Public IPv4 address assigned to the EC2 instance."
  value       = module.ec2_instance.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = module.ec2_instance.public_dns
}

output "private_ip" {
  description = "Private IPv4 address assigned to the EC2 instance."
  value       = module.ec2_instance.private_ip
}
