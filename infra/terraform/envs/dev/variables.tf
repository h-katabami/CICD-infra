variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type     = string
  default  = null
  nullable = true
}

variable "connection_name" {
  type = string
}

variable "artifact_bucket_name" {
  type = string
}

variable "repositories" {
  type = map(object({
    full_repository_id      = string
    branch_name             = string
    app_repository_name     = string
    build_artifact_bucket   = string
    manual_approval_enabled = optional(bool, false)
    frontend_source_dir     = optional(string, "front")
    frontend_entry_file     = optional(string, "index.html")
    frontend_build_prefix   = optional(string, "front")
    lambda_source_dir       = optional(string, "lambdas/GuidanceHandler")
    lambda_package_name     = optional(string, "guidance-handler.zip")
    lambda_build_prefix     = optional(string, "lambda/guidance-handler")
    terraform_version       = optional(string, "1.6.6")
    terraform_env_dir       = optional(string, "infra/terraform/envs")
    scenario_dir            = optional(string, "scenario")
    gram_dir                = optional(string, "gram")
  }))
}