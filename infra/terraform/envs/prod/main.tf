terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  buildspec_template_dir = "${path.module}/../../modules/code-pipeline/templates"
}

module "code_connections" {
  source = "../../modules/code_connections"

  connections = var.code_connections
}

module "s3_bucket" {
  count = var.manage_state_bucket && contains(keys(var.s3_buckets), "backend") ? 1 : 0

  source = "../../modules/s3-bucket"

  bucket_name             = var.s3_buckets["backend"].bucket_name
  versioning_enabled      = var.s3_buckets["backend"].versioning_enabled
  encryption_algorithm    = var.s3_buckets["backend"].encryption_algorithm
  block_public_acls       = var.s3_buckets["backend"].block_public_acls
  block_public_policy     = var.s3_buckets["backend"].block_public_policy
  ignore_public_acls      = var.s3_buckets["backend"].ignore_public_acls
  restrict_public_buckets = var.s3_buckets["backend"].restrict_public_buckets
}

module "code_pipeline" {
  for_each = var.repositories

  source = "../../modules/code-pipeline"

  name_prefix          = "${each.key}-prod"
  artifact_bucket_name = var.artifact_bucket_name
  connection_arn       = module.code_connections.connections["github"].arn
  full_repository_id   = "${var.github_org}/${each.key}"
  branch_name          = each.value.branch_name
  deploy_env           = var.environment
  manual_approval      = each.value.manual_approval
  deploy_lambda        = each.value.deploy_lambda
  deploy_frontend      = each.value.deploy_frontend
  lambda_buildspec_content = templatefile("${local.buildspec_template_dir}/lambda-build.yml.tftpl", {
    lambda_source_dir   = each.value.lambda_source_dir
    lambda_package_name = each.value.lambda_package_name
    lambda_build_prefix = each.value.lambda_build_prefix
  })
  frontend_buildspec_content = templatefile("${local.buildspec_template_dir}/frontend-build.yml.tftpl", {
    frontend_source_dir   = each.value.frontend_source_dir
    frontend_entry_file   = each.value.frontend_entry_file
    frontend_build_prefix = each.value.frontend_build_prefix
  })
  terraform_plan_buildspec_content = templatefile("${local.buildspec_template_dir}/terraform-plan.yml.tftpl", {
    terraform_version = each.value.terraform_version
    terraform_env_dir = each.value.terraform_env_dir
    deploy_lambda     = each.value.deploy_lambda
    deploy_frontend   = each.value.deploy_frontend
  })
  terraform_apply_buildspec_content = templatefile("${local.buildspec_template_dir}/terraform-apply.yml.tftpl", {
    terraform_version = each.value.terraform_version
    terraform_env_dir = each.value.terraform_env_dir
    deploy_lambda     = each.value.deploy_lambda
    deploy_frontend   = each.value.deploy_frontend
    scenario_dir      = each.value.scenario_dir
    gram_dir          = each.value.gram_dir
  })
}