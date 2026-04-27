locals {
  _team_repository_entries = flatten([
    for repo_name, repo in var.repositories : [
      for team_slug, permission in coalesce(repo.teams, {}) : {
        key        = "${repo_name}:${team_slug}"
        repository = repo_name
        team_id    = team_slug
        permission = permission
      }
    ]
  ])
}

resource "github_team_repository" "this" {
  for_each = {
    for entry in local._team_repository_entries :
    entry.key => entry
  }

  team_id    = each.value.team_id
  repository = each.value.repository
  permission = each.value.permission

  depends_on = [github_repository.this]
}
