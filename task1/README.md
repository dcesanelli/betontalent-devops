# DevOps Code Challenge - Task 1: Terraform Module

This repository contains the Terraform configuration created to fulfill Task 1 of the DevOps Code Challenge.

## Architecture Overview

This solution utilizes **AWS Terraform Registry Modules** (`terraform-aws-modules`) to ensure well-defined patterns, adhere to industry standards, and reduce technical debt.

- **Globals**: A custom module used to define common values and baseline tags for the project. These are defined once and passed as parameters to all subsequent modules to ensure consistency.
- **Networking (VPC)**: A custom 3-tier network topology leveraging the official VPC module. It defines and isolates Public, Private, and Database subnets across multiple Availability Zones.
- **Compute (EC2)**: An EC2 instance deployed in the public tier using the official EC2 module. It automatically creates and attaches an IAM Instance Profile granting read access to the RDS master password secret.
- **Database (RDS Postgres)**: Deployed in isolated Database Subnets. It utilizes AWS RDS's native `manage_master_user_password` feature to automatically generate, rotate, and securely store the root password in AWS Secrets Manager.
- **Security - Strict Routing**: The database security group is configured to only accept traffic originating from the compute tier's security group.
- **Security - Zero Hardcoded Secrets**: The EC2 instance retrieves the database credentials dynamically at runtime using an IAM role scoped via the Principle of Least Privilege.
- **State Management**: An S3 backend is used for remote state storage. DynamoDB is implemented for state locking to support team collaboration (per the task constraints), though my modern preference is to utilize `use_lockfile = true` (introduced in Terraform v1.9.0) for native S3 state locking.
- **Environments**: Environment isolation is achieved using Terraform Workspaces (e.g., `dev`, `stg`, `prd`).

---

## Prerequisites

1.  **Terraform**: `v1.14.0` or higher installed.
2.  **AWS CLI**: Configured with valid programmatic credentials (`aws configure`).

---

## Deployment Guide

> **Note on Bootstrapping:** Managing Terraform state creates a classic "chicken-and-egg" scenario. We need S3 and DynamoDB resources to manage our remote state, but we need Terraform to create those resources first. The preliminary steps below outline how to launch these initial resources using a local state before migrating to a remote backend. This can be avoided when using tools like Terragrunt, that takes care of that, or using HCP Terraform, that stores state in the cloud.

### Step 1: Bootstrap Remote State Infrastructure

Execute these steps within the `bootstrap` directory using an IAM user with permissions to create DynamoDB tables, S3 buckets, and KMS keys.

1.  Ensure the backend configuration in `versions.tf` is set to `"local"`.
2.  Run `terraform init` to initialize the working directory.
3.  Run `terraform apply` to provision the state-management resources. This will generate a local `terraform.tfstate` file.
4.  Once the AWS resources are deployed, update the backend configuration block in `versions.tf` from `"local"` to `"s3"`, referencing your newly created bucket and table.
5.  Run `terraform init -migrate-state` to securely move your local state to the new remote S3 backend.
6.  Remote state and locking are now fully configured for production use.

### Step 2: Deploy the Main Infrastructure

Return to the root directory of the project to deploy the core architecture.

1.  Run `terraform init` to initialize the main project and its remote backend.
2.  Create or select your environment workspace: `terraform workspace new <environment_name>` (e.g., `dev`, `stg` or `prd`).
3.  Apply the configuration using the environment-specific variables: `terraform apply -var-file=./envs/<environment_name>.tfvars`.
