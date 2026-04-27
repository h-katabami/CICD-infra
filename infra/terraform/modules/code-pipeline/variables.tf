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

variable "manual_approval" {
  type    = bool
  default = false
}

variable "deploy_lambda" {
  type    = bool
  default = true
}

variable "deploy_frontend" {
  type    = bool
  default = true
}

variable "build_image" {
  type    = string
  default = "aws/codebuild/standard:7.0"
}

variable "build_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}

variable "lambda_buildspec_content" {
  type = string
}

variable "frontend_buildspec_content" {
  type = string
}

variable "terraform_plan_buildspec_content" {
  type = string
}

variable "terraform_apply_buildspec_content" {
  type = string
}