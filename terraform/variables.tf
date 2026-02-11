variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "nonprod"
}

variable "name_prefix" {
  type    = string
  default = "nti-final"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "tags" {
  type    = map(string)
  default = {}
}

# ================================
# IRSA Configuration
# ================================
variable "create_app_irsa" {
  type        = bool
  description = "Create IRSA role for application workloads"
  default     = true
}

variable "app_namespace" {
  type        = string
  description = "Kubernetes namespace for the application"
  default     = "default"
}

variable "app_service_account" {
  type        = string
  description = "Kubernetes service account name for the application"
  default     = "nti-app-sa"
}

# ================================
# SSM / Secrets Configuration
# ================================
variable "mongodb_uri" {
  type        = string
  description = "MongoDB Atlas connection URI"
  default     = ""
  sensitive   = true
}

# ================================
# API Gateway Configuration
# ================================
variable "enable_api_gateway" {
  type        = bool
  description = "Enable API Gateway"
  default     = false
}

variable "ingress_lb_listener_arn" {
  type        = string
  description = "ARN of the ingress load balancer listener"
  default     = ""
}

variable "ingress_host" {
  type        = string
  description = "Host header for ingress routing"
  default     = "app.internal"
}

variable "cors_allowed_origins" {
  type        = list(string)
  description = "CORS allowed origins"
  default     = ["*"]
}

variable "api_gateway_domain" {
  type        = string
  description = "Custom domain for API Gateway"
  default     = ""
}

variable "api_gateway_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for API Gateway custom domain"
  default     = ""
}

