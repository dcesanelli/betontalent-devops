# Create the EC2 instance with the necessary IAM role to access the RDS secret
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.2"

  name = "${var.globals.name_prefix}-server"

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  associate_public_ip_address = true

  vpc_security_group_ids = [var.instance_sg_id]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 to access RDS secret and connect via SSM"

  iam_role_policies = merge(
    {
      # Added SSM Managed Instance Core policy to allow SSM Session Manager access
      SSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    },
    # Conditionally add Secrets Manager access policy if a secret ARN is provided
    var.create_secret_policy ? {
      SecretsManagerAccess = aws_iam_policy.secrets_manager_policy[0].arn
    } : {}
  )

  # Added EBS volume with encryption for Task 2, only if a KMS key ARN is provided 
  # to have backwards compatibility with Task 1 where this variable is not set.
  root_block_device = {
    encrypted   = var.kms_key_arn != ""
    kms_key_id  = var.kms_key_arn != "" ? var.kms_key_arn : null
    volume_type = "gp3"
    volume_size = 20
  }

  # Added metadata options to require IMDSv2 for enhanced security as part of Task 2
  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.globals.global_tags, {
    Name = "EC2 Instance"
  })
}

# IAM policy to allow EC2 to read the RDS password from Secrets Manager
resource "aws_iam_policy" "secrets_manager_policy" {
  # Only create this policy if create_secret_policy is true
  count = var.create_secret_policy ? 1 : 0

  name        = "${var.globals.name_prefix}-secrets-policy"
  description = "Allows EC2 to read the RDS password from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = var.db_secret_arn
      }
    ]
  })
}
