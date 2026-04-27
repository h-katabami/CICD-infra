output "code_connections" {
  value = module.code_connections.connections
}

output "pipeline_names" {
  value = {
    for key, module_instance in module.code_pipeline : key => module_instance.pipeline_name
  }
}

output "github_actions_role_arns" {
  value = {
    for key, module_instance in module.github_actions_role : key => module_instance.role_arn
  }
}