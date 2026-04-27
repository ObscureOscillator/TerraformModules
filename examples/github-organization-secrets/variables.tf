variable "github_token" {
  description = "GitHub personal access token with org admin permissions"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "The GitHub organization login name (slug)"
  type        = string
}

variable "secrets" {
  description = "Map of Actions organization secrets keyed by secret name"
  type = map(object({
    visibility              = string
    plaintext_value         = string
    selected_repository_ids = optional(list(number), [])
  }))
  sensitive = true
  default   = {}
}
