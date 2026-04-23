output "connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}

output "pipeline_names" {
  value = {
    for key, module_instance in module.repository_pipeline : key => module_instance.pipeline_name
  }
}