output "teams" {
  description = "Map of managed teams with their ID, slug, and node ID"
  value       = module.org_teams.teams
}

output "team_memberships" {
  description = "Map of team memberships keyed by \"team_name:username\""
  value       = module.org_teams.team_memberships
}
