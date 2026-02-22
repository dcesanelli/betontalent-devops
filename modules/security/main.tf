# KMS Key centralized for all encryption needs in Task 2
resource "aws_kms_key" "central_key" {
  description             = "KMS key for Task 2 - Encryption for security services"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Root account full control
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.globals.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },

      # Allow CloudTrail (restricted to this account)
      {
        Sid    = "AllowCloudTrailUse"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:${var.globals.region}:${var.globals.account_id}:trail/${var.globals.name_prefix}-trail"
          }
        }
      },

      # Allow CloudWatch Logs (restricted to specific log group)
      {
        Sid    = "AllowCloudWatchLogsUse"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.globals.region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${var.globals.region}:${var.globals.account_id}:log-group:/aws/cloudtrail/${var.globals.name_prefix}"
          }
        }
      }
    ]
  })

  tags = var.globals.global_tags
}

# S3 bucket for CloudTrail logs with encryption and access policies
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "${var.globals.name_prefix}-cloudtrail-logs-${var.globals.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_encryption" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.central_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Block public access to the CloudTrail logs bucket
resource "aws_s3_bucket_public_access_block" "cloudtrail_access_block" {
  bucket                  = aws_s3_bucket.cloudtrail_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy to allow CloudTrail to write logs and read ACLs
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck", Effect = "Allow", Principal = { Service = "cloudtrail.amazonaws.com" },
        Action = "s3:GetBucketAcl", Resource = aws_s3_bucket.cloudtrail_logs.arn
      },
      {
        Sid       = "AWSCloudTrailWrite", Effect = "Allow", Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:PutObject", Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/*",
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      }
    ]
  })
}

# Create CloudTrail to log all API calls across the account and regions, with encryption and validation enabled
resource "aws_cloudtrail" "main" {
  name                          = "${var.globals.name_prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.central_key.arn

  depends_on = [aws_s3_bucket_policy.cloudtrail_policy]
}

# Add CloudWatch Logs integration for CloudTrail to enable real-time monitoring and alerting on security events
resource "aws_cloudwatch_log_group" "cloudtrail_logs_group" {
  name              = "/aws/cloudtrail/${var.globals.name_prefix}"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.central_key.arn
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized_calls" {
  name           = "UnauthorizedAPICalls"
  pattern        = "{($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\")}"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_logs_group.name

  metric_transformation {
    name      = "UnauthorizedAPICalls"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

# Create a CloudWatch alarm to alert on unauthorized API calls detected by the metric filter
resource "aws_cloudwatch_metric_alarm" "unauthorized_alarm" {
  alarm_name          = "${var.globals.name_prefix}-unauthorized-api-calls"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnauthorizedAPICalls"
  namespace           = "CloudTrailMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alert when unauthorized API calls are detected."
}
