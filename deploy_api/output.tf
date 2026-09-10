output "endpoint" {
  value = aws_api_gateway_stage.default.invoke_url
}

output "api_key" {
  value = nonsensitive(aws_api_gateway_api_key.default.value)
}
