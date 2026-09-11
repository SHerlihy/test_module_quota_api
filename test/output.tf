output "api_name_to_access" {
  value = { for api_name in local.api_names : api_name => {
    endpoint : module.deploy_apis[api_name].endpoint,
    api_key : module.deploy_apis[api_name].api_key
  } }
}
