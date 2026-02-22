# Bet On Talent - DevOps Code Challenge

## Introduction

The DevOps Code Challenge aims to assess candidates' ability to design, implement, and manage scalable, secure, and automated infrastructure using modern DevOps practices. Participants will demonstrate proficiency in CI/CD pipelines, infrastructure as code (laC), containerization, cloud management, monitoring, and security best practices. The challenge evaluates problem-solving skills, automation capabilities, and the ability to optimize workflows for efficiency, reliability, and scalability in real-world DevOps environments.

---

## [Task 1: Terraform Module](https://github.com/dcesanelli/betontalent-devops/blob/task1/task1/README.md)

### Context

You're a DevOps engineer tasked with managing cloud resources at your organisation. The team has decided to use Terraform for infrastructure as code, and you've been assigned to lead the initiative.

### Objective

Write a Terraform configuration that accomplishes the following:

- Utilizes Terraform modules to create an AWS VPC.
- Inside this VPC, deploy an EC2 instance and an RDS instance.
- Use outputs to display essential information about the deployed resources, such as IPs and DNS names.
- Implement remote state management using AWS S3 and state locking with DynamoDB.
- Make sure to use variables to make your modules reusable.
- Use locals to define any constant values or computations that are reused within the configuration.

### Constraints

- Your Terraform configuration should adhere to best practices like proper formatting, commenting, and resource naming conventions.
- Ensure your code is idempotent, meaning running it multiple times won't cause changes unless the actual configuration has changed.

### Bonus

- Implement a basic level of security by using AWS security groups to restrict traffic.
- Use Terraform workspaces to manage different environments (e.g., staging, production).

### Deliverables

- The Terraform configuration files.
- A README explaining:
  - How to use the modules.
  - Any prerequisites or dependencies.
  - How to initialize and apply the configuration.
  - Any assumptions or design choices made.

---

## [Task 2: AWS Cloud Security](./task2/README.md)

### Context

You are a DevOps engineer in a company that is migrating its on-premises applications to AWS. You've been tasked with ensuring the security posture of your cloud environment.

### Objective

Create an Infrastructure as Code (laC) template using Terraform that accomplishes the following:

- Sets up a VPC (Virtual Private Cloud) with private and public subnets.
- Deploys an EC2 instance into the private subnet.
- Sets up a Security Group that allows only necessary ports to be open.
- Uses IAM Roles to grant the EC2 instance only the permissions it needs (Least Privilege).
- Set up CloudTrail to log API calls for your account.
- Enable encryption for any storage services you use (EBS, S3, etc.)

### Constraints

- Use Terraform to create your infrastructure.
- Make use of modules to make your code re-usable.
- Incorporate best practices for AWS security (e.g., enable VPC flow logs, disable root user, etc.)

### Bonus

- Implement AWS Config to enforce security policies.
- Set up a CloudWatch Alarm that triggers if any unauthorized actions are performed.
- Use AWS Secrets Manager to store any sensitive information.

### Deliverables

- Terraform files (.tf) for your infrastructure.
- A README file that explains:
  - How to deploy your infrastructure.
  - Security best practices that you implemented.
  - Any assumptions or design choices you made.

---

## [Task 3: AWS Lambda/Terraform Troubleshooting](https://github.com/dcesanelli/devops-aws-lambda-troubleshooting-files)

Solution in [https://github.com/dcesanelli/devops-aws-lambda-troubleshooting-files](https://github.com/dcesanelli/devops-aws-lambda-troubleshooting-files)

**Directory Structure:**

- `project-root/`
  - `terraform/`
    - `main.tf`
    - `variables.tf`
    - `outputs.tf`
  - `lambda/`
    - `handler.py`
    - `requirements.txt`
  - `README.md`
- All files located here.

Welcome to SpinTech, a leading tech company that specialises in cloud-native solutions. You are part of the DevOps team and are responsible for managing and maintaining the infrastructure. Everything at SpinTech is deployed as code, and you use Terraform extensively for provisioning AWS resources. Late one evening, you receive a notification that there are issues with a newly deployed Lambda function. The Lambda function is throwing errors, and there are issues with the S3 bucket where it's supposed to store data. You suspect there might also be some IAM role issues, but you're not sure yet. Your task is to identify and resolve the issues as quickly as possible. You have a brief window late at night to fix this, as that is the least traffic period, and you need to ensure minimal disruption.

### Your Mission

1. Fork the existing project repo and clone it locally.
2. Navigate through the Terraform files, Lambda function code, and other project components to identify what's wrong.
3. Fix the broken parts and ensure that the Terraform configuration is idempotent and applies without errors.
4. Test to confirm that the Lambda function is now working as expected and the S3 bucket is correctly configured.
5. Document the changes you've made and what each change accomplishes.

### Constraints

- You cannot change the Terraform provider settings.
- You are limited to the current AWS services and can't introduce a new service for this task.
- All changes should be implemented via code (Infrastructure as Code).

### Success Criteria

- Terraform code applies without any errors.
- Lambda function executes successfully and performs its task.
- S3 bucket is correctly configured and accessible by the Lambda function.

---

## Submission Guidelines

- The code should be well-documented, explaining the overall structure and any critical functions.
- Use version control (e.g., Git) and share a link to the repository.
