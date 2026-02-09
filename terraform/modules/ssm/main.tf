# ============================================================================
# AWS SSM Parameter Store - Secrets Management
# ============================================================================

# KMS key for encrypting SecureString parameters
resource "aws_kms_key" "ssm" {
  description             = "KMS key for SSM Parameter Store - ${var.project_name}-${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow EKS workloads to decrypt"
        Effect = "Allow"
        Principal = {
          AWS = var.eks_node_role_arn
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ssm-key"
  })
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/${var.project_name}-${var.environment}-ssm"
  target_key_id = aws_kms_key.ssm.key_id
}

# Get current AWS account
data "aws_caller_identity" "current" {}

# MongoDB Atlas URI parameter (placeholder - value set externally)
resource "aws_ssm_parameter" "mongodb_uri" {
  name        = "/${var.project_name}/${var.environment}/mongodb/uri"
  description = "MongoDB Atlas connection URI"
  type        = "SecureString"
  value       = var.mongodb_uri != "" ? var.mongodb_uri : "placeholder"
  key_id      = aws_kms_key.ssm.key_id

  lifecycle {
    ignore_changes = [value]
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-mongodb-uri"
    Application = "mongodb"
  })
}

# Database credentials parameter
resource "aws_ssm_parameter" "db_credentials" {
  name        = "/${var.project_name}/${var.environment}/database/credentials"
  description = "Database credentials JSON"
  type        = "SecureString"
  value       = var.db_credentials != "" ? var.db_credentials : jsonencode({ username = "placeholder", password = "placeholder" })
  key_id      = aws_kms_key.ssm.key_id

  lifecycle {
    ignore_changes = [value]
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-db-credentials"
    Application = "database"
  })
}

# API keys parameter
resource "aws_ssm_parameter" "api_keys" {
  name        = "/${var.project_name}/${var.environment}/api/keys"
  description = "API keys JSON"
  type        = "SecureString"
  value       = var.api_keys != "" ? var.api_keys : jsonencode({ internal = "placeholder" })
  key_id      = aws_kms_key.ssm.key_id

  lifecycle {
    ignore_changes = [value]
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-api-keys"
    Application = "api"
  })
}

# Generic application secrets
resource "aws_ssm_parameter" "app_secrets" {
  for_each = var.additional_secrets

  name        = "/${var.project_name}/${var.environment}/${each.key}"
  description = each.value.description
  type        = "SecureString"
  value       = each.value.value
  key_id      = aws_kms_key.ssm.key_id

  lifecycle {
    ignore_changes = [value]
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-${replace(each.key, "/", "-")}"
    Application = split("/", each.key)[0]
  })
}

# IAM policy for reading SSM parameters
resource "aws_iam_policy" "ssm_read" {
  name        = "${var.project_name}-${var.environment}-ssm-read"
  description = "Policy to read SSM parameters for ${var.project_name} ${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadParameters"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.environment}/*"
      },
      {
        Sid    = "DecryptParameters"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.ssm.arn
      }
    ]
  })

  tags = var.tags
}

data "aws_region" "current" {}
