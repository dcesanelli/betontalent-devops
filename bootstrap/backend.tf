terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.33"
    }
  }

  # For bootstrap, we'll use local state. 
  # After bootstrapping, we can switch to S3 backend for remote state management.

  # backend "local" {
  # }

  backend "s3" {
    bucket         = "dcesanelli-terraform-state"
    key            = "dcesanelli-backend-terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dcesanelli-terraform-state-locks"
  }
}
