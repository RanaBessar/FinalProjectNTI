# ============================================================================
# SSM Parameter Store Module Variables
# ============================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "eks_node_role_arn" {
  description = "ARN of the EKS node IAM role for KMS access"
  type        = string
}

variable "mongodb_uri" {
  description = "MongoDB Atlas connection URI"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_credentials" {
  description = "Database credentials as JSON string"
  type        = string
  default     = ""
  sensitive   = true
}

variable "api_keys" {
  description = "API keys as JSON string"
  type        = string
  default     = ""
  sensitive   = true
}

variable "additional_secrets" {
  description = "Map of additional secrets to create"
  type = map(object({
    description = string
    value       = string
  }))
  default   = {}
  sensitive = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
