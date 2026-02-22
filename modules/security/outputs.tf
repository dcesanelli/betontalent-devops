output "kms_key_arn" {
  description = "ARN of the KMS key used for encrypting resources in this module"
  value       = aws_kms_key.central_key.arn
}
