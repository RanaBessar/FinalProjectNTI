# ============================================================================
# SSM Parameter Store Module Outputs
# ============================================================================

output "kms_key_id" {
  description = "KMS key ID for SSM parameters"
  value       = aws_kms_key.ssm.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN for SSM parameters"
  value       = aws_kms_key.ssm.arn
}

output "kms_alias" {
  description = "KMS key alias"
  value       = aws_kms_alias.ssm.name
}

output "mongodb_uri_parameter_name" {
  description = "SSM parameter name for MongoDB URI"
  value       = aws_ssm_parameter.mongodb_uri.name
}

output "mongodb_uri_parameter_arn" {
  description = "SSM parameter ARN for MongoDB URI"
  value       = aws_ssm_parameter.mongodb_uri.arn
}

output "db_credentials_parameter_name" {
  description = "SSM parameter name for database credentials"
  value       = aws_ssm_parameter.db_credentials.name
}

output "api_keys_parameter_name" {
  description = "SSM parameter name for API keys"
  value       = aws_ssm_parameter.api_keys.name
}

output "ssm_read_policy_arn" {
  description = "IAM policy ARN for reading SSM parameters"
  value       = aws_iam_policy.ssm_read.arn
}

output "parameter_path_prefix" {
  description = "SSM parameter path prefix"
  value       = "/${var.project_name}/${var.environment}"
}

output "additional_parameter_names" {
  description = "Map of additional parameter names"
  value       = { for k, v in aws_ssm_parameter.app_secrets : k => v.name }
}
