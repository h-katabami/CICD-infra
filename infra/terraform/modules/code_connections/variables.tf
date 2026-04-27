variable "connections" {
  type = map(object({
    name          = string
    provider_type = optional(string, "GitHub")
  }))
  default = {}
}
