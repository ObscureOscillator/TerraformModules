variable "secrets" {
  description = "Map of Actions organization secrets keyed by secret name"
  type = map(object({
    # visibility: which repositories can access this secret
    # "all"      - all repositories in the organization
    # "private"  - all private repositories in the organization
    # "selected" - only the repositories listed in selected_repository_ids
    visibility = string

    # plaintext_value: the secret value; encrypted by the provider before storage
    plaintext_value = string

    # selected_repository_ids: repository IDs that may access this secret.
    # Required when visibility = "selected"; ignored otherwise.
    selected_repository_ids = optional(list(number), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for s in values(var.secrets) :
      contains(["all", "private", "selected"], s.visibility)
    ])
    error_message = "Each secret visibility must be \"all\", \"private\", or \"selected\"."
  }

  validation {
    condition = alltrue([
      for s in values(var.secrets) :
      s.visibility != "selected" || length(s.selected_repository_ids) > 0
    ])
    error_message = "selected_repository_ids must contain at least one repository ID when visibility is \"selected\"."
  }
}
