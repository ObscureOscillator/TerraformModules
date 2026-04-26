locals {
  teams_config = yamldecode(file("${path.module}/teams.yaml"))
}

module "org_teams" {
  source = "../../modules/github-organization-teams"

  teams = local.teams_config.teams
}
