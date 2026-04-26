variable "organization" {
  description = "Configuration for the GitHub organization"
  type = object({
    billing_email = string
    display_name  = optional(string)
    description   = optional(string, "")

    profile = optional(object({
      company          = optional(string)
      blog             = optional(string)
      email            = optional(string)
      twitter_username = optional(string)
      location         = optional(string)
    }), {})

    projects = optional(object({
      has_organization_projects     = optional(bool, true)
      has_repository_projects       = optional(bool, true)
      default_repository_permission = optional(string, "read")
    }), {})

    member_permissions = optional(object({
      members_can_create_repositories          = optional(bool, true)
      members_can_create_public_repositories   = optional(bool, true)
      members_can_create_private_repositories  = optional(bool, true)
      members_can_create_internal_repositories = optional(bool, false)
      members_can_create_pages                 = optional(bool, true)
      members_can_create_public_pages          = optional(bool, true)
      members_can_create_private_pages         = optional(bool, true)
      members_can_fork_private_repositories    = optional(bool, false)
      web_commit_signoff_required              = optional(bool, false)
    }), {})

    security = optional(object({
      advanced_security_enabled_for_new_repositories               = optional(bool, false)
      dependabot_alerts_enabled_for_new_repositories               = optional(bool, false)
      dependabot_security_updates_enabled_for_new_repositories     = optional(bool, false)
      dependency_graph_enabled_for_new_repositories                = optional(bool, false)
      secret_scanning_enabled_for_new_repositories                 = optional(bool, false)
      secret_scanning_push_protection_enabled_for_new_repositories = optional(bool, false)
    }), {})
  })
}
