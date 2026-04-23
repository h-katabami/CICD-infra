variable "name_prefix" {
  type = string
}

variable "artifact_bucket_name" {
  type = string
}

variable "connection_arn" {
  type = string
}

variable "full_repository_id" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "deploy_env" {
  type = string
}

variable "app_repository_name" {
  type = string
}

variable "build_artifact_bucket" {
  type = string
}

variable "manual_approval_enabled" {
  type    = bool
  default = false
}

variable "build_image" {
  type    = string
  default = "aws/codebuild/standard:7.0"
}

variable "build_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}

variable "lambda_buildspec_path" {
  type    = string
  default = "buildspec/lambda-build.yml"
}

variable "frontend_buildspec_path" {
  type    = string
  default = "buildspec/frontend-build.yml"
}

variable "terraform_plan_buildspec_path" {
  type    = string
  default = "buildspec/terraform-plan.yml"
}

variable "terraform_apply_buildspec_path" {
  type    = string
  default = "buildspec/terraform-apply.yml"
}