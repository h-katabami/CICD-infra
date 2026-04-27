variable "role_name" {
  type = string
}

variable "repository_owner" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "managed_policy_arns" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

variable "inline_policy_json" {
  type     = string
  default  = null
  nullable = true
}
