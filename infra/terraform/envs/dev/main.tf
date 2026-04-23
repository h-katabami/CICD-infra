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
}