output "lambda_function_name" {
  description = "The Lambda function backing the route."
  value       = aws_lambda_function.handler.function_name
}

output "resource_id" {
  description = "The API Gateway resource ID for the new route."
  value       = aws_api_gateway_resource.route.id
}

output "route" {
  description = "The route created by this module."
  value       = "${var.http_method} /${var.route_path}"
}
