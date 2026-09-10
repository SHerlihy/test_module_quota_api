output "api_id" {
  value = aws_api_gateway_rest_api.default.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.default.resource_id
}
