module "globals" {
  source = "../modules/globals"

  project_prefix = "dcesanelli"
  project        = "Daniel DevOps Challenge Bootstrap"
}

# Create S3 bucket for Terraform state with versioning and encryption enabled
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${module.globals.project_prefix}-terraform-state"

  # Prevent accidental deletion of the S3 bucket to protect Terraform state
  lifecycle {
    prevent_destroy = true
  }

  tags = merge(module.globals.global_tags, {
    Name = "Terraform State Bucket"
  })
}

# Enable versioning, encryption, and block public access for the S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create a DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${module.globals.project_prefix}-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(module.globals.global_tags, {
    Name = "Terraform State Lock Table"
  })
}
