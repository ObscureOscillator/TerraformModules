resource "github_team" "this" {
  for_each = var.teams

  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

locals {
  team_memberships = merge([
    for team_name, team in var.teams : {
      for username, role in team.members :
      "${team_name}:${username}" => {
        team_name = team_name
        username  = username
        role      = role
      }
    }
  ]...)
}

resource "github_team_membership" "this" {
  for_each = local.team_memberships

  team_id  = github_team.this[each.value.team_name].id
  username = each.value.username
  role     = each.value.role
}
