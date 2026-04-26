resource "github_organization_settings" "this" {
  billing_email = var.organization.billing_email
  name          = var.organization.display_name
  description   = var.organization.description

  # Profile
  company          = var.organization.profile.company
  blog             = var.organization.profile.blog
  email            = var.organization.profile.email
  twitter_username = var.organization.profile.twitter_username
  location         = var.organization.profile.location

  # Projects & repository defaults
  has_organization_projects     = var.organization.projects.has_organization_projects
  has_repository_projects       = var.organization.projects.has_repository_projects
  default_repository_permission = var.organization.projects.default_repository_permission

  # Member permissions
  members_can_create_repositories          = var.organization.member_permissions.members_can_create_repositories
  members_can_create_public_repositories   = var.organization.member_permissions.members_can_create_public_repositories
  members_can_create_private_repositories  = var.organization.member_permissions.members_can_create_private_repositories
  members_can_create_internal_repositories = var.organization.member_permissions.members_can_create_internal_repositories
  members_can_create_pages                 = var.organization.member_permissions.members_can_create_pages
  members_can_create_public_pages          = var.organization.member_permissions.members_can_create_public_pages
  members_can_create_private_pages         = var.organization.member_permissions.members_can_create_private_pages
  members_can_fork_private_repositories    = var.organization.member_permissions.members_can_fork_private_repositories
  web_commit_signoff_required              = var.organization.member_permissions.web_commit_signoff_required

  # Security features applied to new repositories
  advanced_security_enabled_for_new_repositories               = var.organization.security.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.organization.security.dependabot_alerts_enabled_for_new_repositories
  dependabot_security_updates_enabled_for_new_repositories     = var.organization.security.dependabot_security_updates_enabled_for_new_repositories
  dependency_graph_enabled_for_new_repositories                = var.organization.security.dependency_graph_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.organization.security.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.organization.security.secret_scanning_push_protection_enabled_for_new_repositories
}
