variable "globals" {
  description = "Output from globals module"
  type = object({
    account_id     = string
    env            = string
    global_tags    = map(string)
    project_prefix = string
    name_prefix    = string
    region         = string
  })
}

variable "vpc_id" {
  description = "ID of the VPC to launch instances in"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch instances in"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_sg_id" {
  description = "The security group ID for the EC2 instance to allow database access"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string
  default     = ""
}

# Added variables for Task 2 enhancements, with defaults for backwards compatibility with Task 1
variable "create_secret_policy" {
  description = "Set to true to create the secrets manager IAM policy"
  type        = bool
  default     = true
}
variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the EBS root volume"
  type        = string
  default     = ""
}

variable "is_public" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}
