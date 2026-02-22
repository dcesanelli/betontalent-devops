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
  type        = string
  description = "The VPC ID where the database is deployed"
}

variable "db_sg_id" {
  type        = string
  description = "The security group ID for the database to allow access from the EC2 instance"
}

variable "db_subnet_group_name" {
  type        = string
  description = "The name of the subnet group for the database"
}

variable "db_instance_class" {
  type        = string
  description = "The instance class for the database"
}

variable "engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "17.6"
}

variable "family" {
  description = "RDS family"
  type        = string
  default     = "postgres17"
}

variable "major_engine_version" {
  description = "RDS major engine version"
  type        = string
  default     = "17"
}

variable "db_name" {
  description = "Name of the initial database to create in the RDS instance"
  type        = string
  default     = "challenge"
}

variable "db_username" {
  type        = string
  description = "Username for the database master user"
  default     = "root"
}
