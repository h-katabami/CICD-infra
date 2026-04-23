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
  buildspec_template_dir = "${path.module}/../../modules/repository-pipeline/templates"
}

resource "aws_codestarconnections_connection" "github" {
  name          = var.connection_name
  provider_type = "GitHub"
}

module "repository_pipeline" {
  for_each = var.repositories

  source = "../../modules/repository-pipeline"

  name_prefix             = "${each.key}-dev"
  artifact_bucket_name    = var.artifact_bucket_name
  connection_arn          = aws_codestarconnections_connection.github.arn
  full_repository_id      = each.value.full_repository_id
  branch_name             = each.value.branch_name
  deploy_env              = "dev"
  app_repository_name     = each.value.app_repository_name
  build_artifact_bucket   = each.value.build_artifact_bucket
  manual_approval_enabled = each.value.manual_approval_enabled
  lambda_buildspec_content = templatefile("${local.buildspec_template_dir}/lambda-build.yml.tftpl", {
    lambda_source_dir   = each.value.lambda_source_dir
    lambda_package_name = each.value.lambda_package_name
    lambda_build_prefix = each.value.lambda_build_prefix
  })
  frontend_buildspec_content = templatefile("${local.buildspec_template_dir}/frontend-build.yml.tftpl", {
    frontend_source_dir = each.value.frontend_source_dir
    frontend_entry_file = each.value.frontend_entry_file
    frontend_build_prefix = each.value.frontend_build_prefix
  })
  terraform_plan_buildspec_content = templatefile("${local.buildspec_template_dir}/terraform-plan.yml.tftpl", {
    terraform_env_dir = each.value.terraform_env_dir
  })
  terraform_apply_buildspec_content = templatefile("${local.buildspec_template_dir}/terraform-apply.yml.tftpl", {
    terraform_env_dir = each.value.terraform_env_dir
    scenario_dir      = each.value.scenario_dir
    gram_dir          = each.value.gram_dir
  })
}