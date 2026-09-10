# will have to taint
resource "aws_api_gateway_deployment" "default" {
  rest_api_id = var.api_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "default" {
  rest_api_id = var.api_id
  deployment_id = aws_api_gateway_deployment.default.id
  stage_name    = var.stage_name

  tags = var.tags
}

resource "aws_api_gateway_method_settings" "default" {
  for_each = local.paths
  rest_api_id = var.api_id
  stage_name    = var.stage_name
  method_path = each.value

  settings {
    throttling_burst_limit = var.path_to_settings[each.value].burst_limit
    throttling_rate_limit  = var.path_to_settings[each.value].rate_limit
  }
}

resource "aws_api_gateway_api_key" "default" {
  name    = var.stage_name
  enabled = true

  tags = var.tags
}

resource "aws_api_gateway_usage_plan" "default" {
  name    = var.stage_name

  api_stages {
    api_id = var.api_id
    stage    = var.stage_name
  }

  quota_settings {
    limit = var.quota.limit
    period = var.quota.period
  }

  throttle_settings {
    burst_limit = var.throttle.burst
    rate_limit = var.throttle.rate
  }

  tags = var.tags
}

resource "aws_api_gateway_usage_plan_key" "default" {
  key_id        = aws_api_gateway_api_key.default.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.default.id
}
