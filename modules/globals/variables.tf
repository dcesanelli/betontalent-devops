# The following are re-exported later as tags.
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Project prefix for naming resources"
  type        = string
}

variable "project" {
  description = "Project name for tagging and naming purposes"
  type        = string
}
