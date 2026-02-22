# DevOps Code Challenge - Task 2: AWS Cloud Security

This repository contains the Terraform configuration created to fulfill Task 2 of the DevOps Code Challenge.

## Architecture Overview

It uses the base modules in [Task 1: Terraform Module](https://github.com/dcesanelli/betontalent-devops/blob/task1/task1/README.md)

## Task 2 Updates (Changes from Task 1)

In this task, several critical security enhancements were introduced across the infrastructure to harden the environment and improve auditing:

### 1. Compute Module Hardening

- **IMDSv2 Enforcement**: Updated EC2 instance metadata options to strictly require IMDSv2 (`http_tokens = "required"`) to protect against SSRF vulnerabilities.
- **EBS Volume Encryption**: Configured the root block device to be encrypted using a newly provisioned KMS key, maintaining backward compatibility if the key is not provided.
- **SSM Session Manager**: Attached the `AmazonSSMManagedInstanceCore` IAM policy to the EC2 instance profile. This allows secure, audited shell access via AWS Systems Manager without needing to open SSH (port 22) to the internet.

### 2. Networking Security Posture

- **Ingress Hardening**: Removed all default ingress rules from the EC2 instance's security group (`ingress_rules = []`), strictly enforcing a default-deny posture for inbound public traffic.

### 3. New Security Module (Auditing & Monitoring)

- **Centralized KMS Key**: Created a central AWS KMS key with automatic rotation to manage encryption for security services like CloudTrail and CloudWatch.
- **CloudTrail Auditing**: Provisioned a multi-region AWS CloudTrail to log all API calls and global service events. The trail features log file validation to ensure integrity and encrypts data using the central KMS key.
- **Secure S3 Log Storage**: Created an S3 bucket specifically for CloudTrail logs with enforced server-side KMS encryption and strictly blocked public access (`block_public_acls`, `restrict_public_buckets`).
- **Proactive Alerting**: Integrated CloudTrail with CloudWatch Logs. Established a metric filter to actively track unauthorized API calls (filtering for `*UnauthorizedOperation` and `AccessDenied*`) and bound it to a CloudWatch Alarm that triggers when unauthorized calls are detected.

## Prerequisites

1.  **Terraform**: `v1.14.0` or higher installed.
2.  **AWS CLI**: Configured with valid programmatic credentials (`aws configure`).

---

## Deployment Guide

> **Note on Bootstrapping:** Managing Terraform state creates a classic "chicken-and-egg" scenario. We need S3 and DynamoDB resources to manage our remote state, but we need Terraform to create those resources first. The preliminary steps below outline how to launch these initial resources using a local state before migrating to a remote backend.

> **This step is only needeed if not done for Task1**

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
2.  Create or select your environment workspace: `terraform workspace new <environment_name>` (e.g., `dev`).
3.  Apply the configuration using the environment-specific variables: `terraform apply -var-file=./envs/<environment_name>.tfvars`.
