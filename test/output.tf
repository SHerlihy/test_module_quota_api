output "endpoint_list" {
  value = [for path_config in local.path_configs :
  {
        endpoint : "${module.deploy_apis[path_config.api_name].endpoint}/${path_config.route_path}",
        method : path_config.http_method,
        api_key : module.deploy_apis[path_config.api_name].api_key
      }
  ]
}
