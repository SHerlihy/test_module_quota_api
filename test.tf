locals {
  tags = {
    product_id = "quota endpoint"
    facet = "admin"
  }
  high_cost = "highCost"
  low_cost = "lowCost"
  api_names = [local.high_cost, local.low_cost]
}

module "draft_apis" {
  for_each = local.api_names
  source = "./draft_api"

  api_name = each.value
  tags = local.tags
}

locals {
  path_ids = [
    "${local.high_cost}-get",
    "${local.high_cost}-otherGet",
    "${local.low_cost}-post",
    "${local.low_cost}-delete",
  ]
  path_configs = {
    "${local.path_ids[0]}": {
      api_id = module.draft_apis[local.high_cost].api_id
      root_resource_id = module.draft_apis[local.high_cost].root_resource_id
      route_path = local.path_ids[0]
      http_method = "GET"
      lambda_function_name = local.path_ids[0]
      lambda_role_name = local.path_ids[0]
    },
    "${local.path_ids[1]}": {
      api_id = module.draft_apis[local.high_cost].api_id
      root_resource_id = module.draft_apis[local.high_cost].root_resource_id
      route_path = local.path_ids[1]
      http_method = "GET"
      lambda_function_name = local.path_ids[1]
      lambda_role_name = local.path_ids[1]
    },
    "${local.path_ids[2]}": {
      api_id = module.draft_apis[local.low_cost].api_id
      root_resource_id = module.draft_apis[local.low_cost].root_resource_id
      route_path = local.path_ids[2]
      http_method = "POST"
      lambda_function_name = local.path_ids[2]
      lambda_role_name = local.path_ids[2]
    },
    "${local.path_ids[3]}": {
      api_id = module.draft_apis[local.low_cost].api_id
      root_resource_id = module.draft_apis[local.low_cost].root_resource_id
      route_path = local.path_ids[3]
      http_method = "DELETE"
      lambda_function_name = local.path_ids[3]
      lambda_role_name = local.path_ids[3]
    },
  }
}

module "dummy_paths" {
  for_each = local.path_ids
  source = "./endpoint"

  api_id = local.path_configs[each.value].api_id
  root_resource_id = local.path_configs[each.value].root_resource_id
  route_path = local.path_configs[each.value].route_path
  http_method = local.path_configs[each.value].http_method
  lambda_function_name = local.path_configs[each.value].lambda_function_name
  lambda_role_name = local.path_configs[each.value].lambda_role_name
}

locals {
  deploy_config_apis = {
    local.high_cost: {
      api_id: module.draft_apis[local.high_cost].api_id,
      stage_name: local.high_cost,
      quota: {
        limit = 100
        period = "MONTH"
      },
      throttle: {
        burst: 5,
        rate: 2
      },
      method_settings: [
        {
          path: "${local.path_ids[0]}"
          burst_limit: 2
          rate_limit: 1
        },
        {
          path: "${local.path_ids[1]}"
          burst_limit: 2
          rate_limit: 1
        },
      ]
    },
    local.low_cost: {
      api_id: module.draft_apis[local.low_cost].api_id,
      stage_name: local.low_cost,
      quota: {
        limit = 100
        period = "MONTH"
      },
      throttle: {
        burst: 5,
        rate: 2
      },
      method_settings: [
        {
          path: "${local.path_ids[2]}"
          burst_limit: 2
          rate_limit: 1
        },
        {
          path: "${local.path_ids[3]}"
          burst_limit: 2
          rate_limit: 1
        },
      ]
    }
  }
}

module "deploy_apis" {
  for_each = local.api_names
  source = "./deploy_api"

  api_id = each.value.api_id
  stage_name = each.value.stage_name
  quota = each.value.quota
  throttle = each.value.throttle

  method_settings = each.value.method_settings

  tags = local.tags
}

output "api_name_to_access" {
  value = {for api_name in local.api_names : api_name => {
    endpoint: module.deploy_apis[api_name].endpoint,
    api_key: module.deploy_apis[api_name].api_key
  }}
}
