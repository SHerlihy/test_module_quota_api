locals {
  tags = {
    product_id = "quota endpoint"
    facet      = "admin"
  }
  high_cost = "highCost"
  low_cost  = "lowCost"
  api_names = toset([local.high_cost, local.low_cost])
}

module "draft_apis" {
  providers = {
    aws = aws.product_role
  }

  for_each = local.api_names
  source   = "../draft_api"

  api_name = each.value
  tags     = local.tags
}

locals {
  path_ids = [
    "${local.high_cost}-get",
    "${local.high_cost}-otherGet",
    "${local.low_cost}-post",
    "${local.low_cost}-delete",
  ]
  path_configs = {
    (local.path_ids[0]) : {
      api_id               = module.draft_apis[local.high_cost].api_id
      root_resource_id     = module.draft_apis[local.high_cost].root_resource_id
      execution_arn        = module.draft_apis[local.high_cost].execution_arn
      route_path           = local.path_ids[0]
      http_method          = "GET"
      lambda_function_name = local.path_ids[0]
      lambda_role_name     = local.path_ids[0]
    },
    (local.path_ids[1]) : {
      api_id               = module.draft_apis[local.high_cost].api_id
      root_resource_id     = module.draft_apis[local.high_cost].root_resource_id
      execution_arn        = module.draft_apis[local.high_cost].execution_arn
      route_path           = local.path_ids[1]
      http_method          = "GET"
      lambda_function_name = local.path_ids[1]
      lambda_role_name     = local.path_ids[1]
    },
    (local.path_ids[2]) : {
      api_id               = module.draft_apis[local.low_cost].api_id
      root_resource_id     = module.draft_apis[local.low_cost].root_resource_id
      execution_arn        = module.draft_apis[local.low_cost].execution_arn
      route_path           = local.path_ids[2]
      http_method          = "POST"
      lambda_function_name = local.path_ids[2]
      lambda_role_name     = local.path_ids[2]
    },
    (local.path_ids[3]) : {
      api_id               = module.draft_apis[local.low_cost].api_id
      root_resource_id     = module.draft_apis[local.low_cost].root_resource_id
      execution_arn        = module.draft_apis[local.low_cost].execution_arn
      route_path           = local.path_ids[3]
      http_method          = "DELETE"
      lambda_function_name = local.path_ids[3]
      lambda_role_name     = local.path_ids[3]
    },
  }
  path_ids_set = toset(local.path_ids)
}

module "dummy_paths" {
  providers = {
    aws = aws.test_role
  }

  for_each = local.path_ids_set
  source   = "../endpoint"

  api_id               = local.path_configs[each.value].api_id
  root_resource_id     = local.path_configs[each.value].root_resource_id
  execution_arn        = local.path_configs[each.value].execution_arn
  route_path           = local.path_configs[each.value].route_path
  http_method          = local.path_configs[each.value].http_method
  lambda_function_name = local.path_configs[each.value].lambda_function_name
  lambda_role_name     = local.path_configs[each.value].lambda_role_name
}

locals {
  deploy_config_apis = {
    (local.high_cost) : {
      api_id : module.draft_apis[local.high_cost].api_id,
      stage_name : local.high_cost,
      quota : {
        limit : 100
        period : "MONTH"
      },
      throttle : {
        burst : 5,
        rate : 2
      },
      path_to_settings : {
        "${local.path_ids[0]}/GET" : {
          burst_limit : 2
          rate_limit : 1
        },
        "${local.path_ids[1]}/GET" : {
          burst_limit : 2
          rate_limit : 1
        },
      }
    },
    (local.low_cost) : {
      api_id : module.draft_apis[local.low_cost].api_id,
      stage_name : local.low_cost,
      quota : {
        limit  = 100
        period = "MONTH"
      },
      throttle : {
        burst : 5,
        rate : 2
      },
      path_to_settings : {
        "${local.path_ids[2]}/POST" : {
          burst_limit : 2
          rate_limit : 1
        },
        "${local.path_ids[3]}/DELETE" : {
          burst_limit : 2
          rate_limit : 1
        },
      }
    }
  }
}

module "deploy_apis" {
  providers = {
    aws = aws.product_role
  }

  for_each = local.api_names
  source   = "../deploy_api"

  api_id     = local.deploy_config_apis[each.value].api_id
  stage_name = local.deploy_config_apis[each.value].stage_name
  quota      = local.deploy_config_apis[each.value].quota
  throttle   = local.deploy_config_apis[each.value].throttle

  path_to_settings = local.deploy_config_apis[each.value].path_to_settings

  tags = local.tags
}
