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
  }))
}