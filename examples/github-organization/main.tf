module "github_organization" {
  source = "../../modules/github-organization"

  organization = {
    billing_email = "billing@example.com"
    display_name  = "Example Organization"
    description   = "An example GitHub organization managed by Terraform"

    profile = {
      company  = "Example Corp"
      blog     = "https://example.com"
      email    = "hello@example.com"
      location = "Earth"
    }

    projects = {
      has_organization_projects     = true
      has_repository_projects       = true
      default_repository_permission = "read"
    }

    member_permissions = {
      members_can_create_repositories          = true
      members_can_create_public_repositories   = false
      members_can_create_private_repositories  = true
      members_can_create_internal_repositories = false
      members_can_create_pages                 = true
      members_can_create_public_pages          = false
      members_can_create_private_pages         = true
      members_can_fork_private_repositories    = false
      web_commit_signoff_required              = true
    }

    security = {
      advanced_security_enabled_for_new_repositories               = false
      dependabot_alerts_enabled_for_new_repositories               = true
      dependabot_security_updates_enabled_for_new_repositories     = true
      dependency_graph_enabled_for_new_repositories                = true
      secret_scanning_enabled_for_new_repositories                 = true
      secret_scanning_push_protection_enabled_for_new_repositories = true
    }
  }
}
