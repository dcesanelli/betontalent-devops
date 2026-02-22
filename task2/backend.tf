terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.33"
    }
  }

  backend "s3" {
    bucket         = "dcesanelli-terraform-state"
    key            = "dcesanelli-task2-terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dcesanelli-terraform-state-locks"
  }
}
