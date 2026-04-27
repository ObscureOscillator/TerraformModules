locals {
  _environment_entries = flatten([
    for repo_name, repo in var.repositories : [
      for env_name, env_config in coalesce(repo.environments, {}) : {
        key         = "${repo_name}:${env_name}"
        repository  = repo_name
        environment = env_name
        config      = env_config
      }
    ]
  ])

  _reviewer_team_slugs = toset(distinct(flatten([
    for repo in values(var.repositories) : [
      for env_config in values(coalesce(repo.environments, {})) :
      coalesce(try(env_config.reviewers.teams, []), [])
    ]
  ])))

  _reviewer_user_logins = toset(distinct(flatten([
    for repo in values(var.repositories) : [
      for env_config in values(coalesce(repo.environments, {})) :
      coalesce(try(env_config.reviewers.users, []), [])
    ]
  ])))
}

data "github_team" "reviewer" {
  for_each = local._reviewer_team_slugs
  slug     = each.key
}

data "github_user" "reviewer" {
  for_each = local._reviewer_user_logins
  username = each.key
}

resource "github_repository_environment" "this" {
  for_each = {
    for entry in local._environment_entries :
    entry.key => entry
  }

  repository          = each.value.repository
  environment         = each.value.environment
  wait_timer          = each.value.config.wait_timer
  can_admins_bypass   = each.value.config.can_admins_bypass
  prevent_self_review = each.value.config.prevent_self_review

  dynamic "reviewers" {
    for_each = each.value.config.reviewers != null ? [each.value.config.reviewers] : []
    content {
      teams = [
        for slug in coalesce(reviewers.value.teams, []) :
        data.github_team.reviewer[slug].id
      ]
      users = [
        for login in coalesce(reviewers.value.users, []) :
        data.github_user.reviewer[login].id
      ]
    }
  }

  dynamic "deployment_branch_policy" {
    for_each = each.value.config.deployment_branch_policy != null ? [each.value.config.deployment_branch_policy] : []
    content {
      protected_branches     = deployment_branch_policy.value.protected_branches
      custom_branch_policies = deployment_branch_policy.value.custom_branch_policies
    }
  }

  depends_on = [github_repository.this]
}
