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
  iam_role_policies = {
    SecretsManagerAccess = aws_iam_policy.secrets_manager_policy.arn
    # Added SSM Managed Instance Core policy to allow SSM Session Manager access
    SSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = merge(var.globals.global_tags, {
    Name = "EC2 Instance"
  })
}

# IAM policy to allow EC2 to read the RDS password from Secrets Manager
resource "aws_iam_policy" "secrets_manager_policy" {
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
