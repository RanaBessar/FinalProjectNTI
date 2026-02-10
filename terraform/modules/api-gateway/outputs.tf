2026-02-10T00:39:22.4174325Z ##[section]Starting: Validate AWS Credentials
2026-02-10T00:39:22.4183810Z ==============================================================================
2026-02-10T00:39:22.4183960Z Task         : Command line
2026-02-10T00:39:22.4184046Z Description  : Run a command line script using Bash on Linux and macOS and cmd.exe on Windows
2026-02-10T00:39:22.4184184Z Version      : 2.268.0
2026-02-10T00:39:22.4184267Z Author       : Microsoft Corporation
2026-02-10T00:39:22.4184372Z Help         : https://docs.microsoft.com/azure/devops/pipelines/tasks/utility/command-line
2026-02-10T00:39:22.4184488Z ==============================================================================
2026-02-10T00:39:22.7841852Z Generating script.
2026-02-10T00:39:22.7863610Z ========================== Starting Command Output ===========================
2026-02-10T00:39:22.7914308Z [command]/usr/bin/bash --noprofile --norc /home/devops/myagent/_work/_temp/bb9c9e6f-1574-4a96-a822-2401750f12fe.sh
2026-02-10T00:39:22.8050937Z Validating AWS credentials...
2026-02-10T00:39:24.9925489Z 
2026-02-10T00:39:24.9931797Z An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: The security token included in the request is invalid.
2026-02-10T00:39:25.2654913Z 
2026-02-10T00:39:25.2739552Z ##[error]Bash exited with code '254'.
2026-02-10T00:39:25.2801260Z ##[section]Finishing: Validate AWS Credentials
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
