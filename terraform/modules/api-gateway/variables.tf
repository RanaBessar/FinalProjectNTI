# ============================================================================
# API Gateway Module Variables
# ============================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for VPC Link"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for VPC Link"
  type        = list(string)
}

variable "ingress_lb_listener_arn" {
  description = "ARN of the ingress load balancer listener"
  type        = string
  default     = ""
}

variable "ingress_host" {
  description = "Host header to set for ingress requests"
  type        = string
  default     = "app.internal"
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "throttling_burst_limit" {
  description = "Throttling burst limit"
  type        = number
  default     = 1000
}

variable "throttling_rate_limit" {
  description = "Throttling rate limit"
  type        = number
  default     = 500
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "custom_domain_name" {
  description = "Custom domain name for API Gateway (optional)"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ACM certificate ARN for custom domain"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
