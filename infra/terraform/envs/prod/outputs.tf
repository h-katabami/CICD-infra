output "code_connections" {
  value = module.code_connections.connections
}

output "pipeline_names" {
  value = {
    for key, module_instance in module.code_pipeline : key => module_instance.pipeline_name
  }
}