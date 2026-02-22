variable "globals" {
  description = "Output from globals module"
  type = object({
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
  type        = string
  description = "The security group ID for the EC2 instance to allow database access"
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string
}
