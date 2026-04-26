variable "github_token" {
  description = "GitHub personal access token with org admin permissions"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "The GitHub organization login name (slug)"
  type        = string
}
