output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate" {
  value = module.eks.cluster_certificate
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "The ARN of the OIDC Provider for IRSA"
}

output "ebs_csi_driver_role_arn" {
  value       = module.eks.ebs_csi_driver_role_arn
  description = "The ARN of the EBS CSI Driver IAM Role"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

# ================================
# SSM Outputs
# ================================
output "ssm_parameter_path_prefix" {
  value       = module.ssm.parameter_path_prefix
  description = "SSM parameter path prefix for secrets"
}

output "ssm_mongodb_uri_parameter" {
  value       = module.ssm.mongodb_uri_parameter_name
  description = "SSM parameter name for MongoDB URI"
}

output "ssm_kms_key_arn" {
  value       = module.ssm.kms_key_arn
  description = "KMS key ARN for SSM parameter encryption"
}

output "ssm_read_policy_arn" {
  value       = module.ssm.ssm_read_policy_arn
  description = "IAM policy ARN for reading SSM parameters"
}

# ================================
# IRSA Outputs
# ================================
output "app_workload_role_arn" {
  value       = module.eks.app_workload_role_arn
  description = "IAM role ARN for application workloads (IRSA)"
}

# ================================
# API Gateway Outputs (when enabled)
# ================================
output "api_gateway_endpoint" {
  value       = var.enable_api_gateway ? module.api_gateway[0].api_endpoint : null
  description = "API Gateway endpoint URL"
}

output "api_gateway_id" {
  value       = var.enable_api_gateway ? module.api_gateway[0].api_id : null
  description = "API Gateway ID"
}

# ================================
# Cluster Access Details
# ================================
output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
  description = "Command to configure kubectl"
}

