module "org_members" {
  source = "../../modules/github-organization-members"

  members = {
    # Regular members — can interact with repositories but cannot manage the org
    "octocat" = {
      role = "member"
    }
    "monalisa" = {
      role = "member"
    }

    # Admins — have full organization management permissions
    "hubot" = {
      role                 = "admin"
      downgrade_on_destroy = true
    }
  }
}
