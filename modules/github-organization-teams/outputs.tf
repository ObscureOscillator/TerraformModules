output "teams" {
  description = "Map of managed teams with their ID, slug, and node ID"
  value = {
    for name, team in github_team.this :
    name => {
      id      = team.id
      slug    = team.slug
      node_id = team.node_id
    }
  }
}

output "team_memberships" {
  description = "Map of team memberships keyed by \"team_name:username\""
  value = {
    for key, membership in github_team_membership.this :
    key => {
      id   = membership.id
      role = membership.role
      etag = membership.etag
    }
  }
}
