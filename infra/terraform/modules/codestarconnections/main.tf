resource "aws_codestarconnections_connection" "this" {
  for_each = var.connections

  name          = each.value.name
  provider_type = each.value.provider_type
}
