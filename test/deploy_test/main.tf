locals {
  tags = {
    product_id = "quota endpoint"
    facet      = "admin"
  }
  api_names          = data.terraform_remote_state.pre_deploy.outputs.api_names
  deploy_config_apis = data.terraform_remote_state.pre_deploy.outputs.deploy_config_apis
}

module "deploy_apis" {
  providers = {
    aws = aws.product_role
  }

  for_each = local.api_names
  source   = "../../deploy_api"

  api_id           = local.deploy_config_apis[each.value].api_id
  stage_name       = local.deploy_config_apis[each.value].stage_name
  quota            = local.deploy_config_apis[each.value].quota
  throttle         = local.deploy_config_apis[each.value].throttle
  path_to_settings = local.deploy_config_apis[each.value].path_to_settings

  tags = local.tags
}
