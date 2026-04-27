variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type     = string
  default  = null
  nullable = true
}

variable "code_connections" {
  type = map(object({
    name          = string
    provider_type = optional(string, "GitHub")
  }))
  default = {}
}

variable "github_org" {
  type = string
}

variable "artifact_bucket_name" {
  type = string
}

variable "s3_buckets" {
  type = map(object({
    bucket_name             = string
    versioning_enabled      = optional(bool, true)
    encryption_algorithm    = optional(string, "AES256")
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  }))
  default = {}
}

variable "environment" {
  type = string
}

variable "manage_state_bucket" {
  type    = bool
  default = true
}

variable "repositories" {
  type = map(object({
    branch_name           = string
    manual_approval       = optional(bool, false)
    deploy_lambda         = optional(bool, true)
    deploy_frontend       = optional(bool, true)
    frontend_source_dir   = optional(string, "front")
    frontend_entry_file   = optional(string, "index.html")
    frontend_build_prefix = optional(string, "front")
    lambda_source_dir     = optional(string, "lambdas/GuidanceHandler")
    lambda_package_name   = optional(string, "guidance-handler.zip")
    lambda_build_prefix   = optional(string, "lambda/guidance-handler")
    terraform_version     = optional(string, "1.6.6")
    terraform_env_dir     = optional(string, "infra/terraform/envs")
    scenario_dir          = optional(string, "scenario")
    gram_dir              = optional(string, "gram")
  }))
}