# ============================================================================
# API Gateway Module Outputs
# ============================================================================

output "api_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.main.id
}

output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "api_arn" {
  description = "API Gateway ARN"
  value       = aws_apigatewayv2_api.main.arn
}

output "stage_id" {
  description = "Default stage ID"
  value       = aws_apigatewayv2_stage.default.id
}

output "vpc_link_id" {
  description = "VPC Link ID"
  value       = aws_apigatewayv2_vpc_link.main.id
}

output "vpc_link_arn" {
  description = "VPC Link ARN"
  value       = aws_apigatewayv2_vpc_link.main.arn
}

output "log_group_name" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.api_gateway.name
}

output "custom_domain_name" {
  description = "Custom domain name (if configured)"
  value       = var.custom_domain_name != "" ? aws_apigatewayv2_domain_name.main[0].domain_name : null
}

output "custom_domain_target" {
  description = "Custom domain target for DNS (if configured)"
  value       = var.custom_domain_name != "" ? aws_apigatewayv2_domain_name.main[0].domain_name_configuration[0].target_domain_name : null
}
