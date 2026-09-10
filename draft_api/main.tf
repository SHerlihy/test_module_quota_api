resource "aws_api_gateway_rest_api" "default" {
  name           = var.api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_method" "default" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "default" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id

  http_method = aws_api_gateway_method.default.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "default" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method = aws_api_gateway_method.default.http_method

  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Max-Age"       = true
  }
}

resource "aws_api_gateway_integration_response" "default" {
  depends_on = [aws_api_gateway_integration.default]

  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method = aws_api_gateway_method.default.http_method
  status_code = aws_api_gateway_method_response.default.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'accept,cache-control,content-type,x-api-key'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,PATCH,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Max-Age"       = "'86400'"
  }
}
