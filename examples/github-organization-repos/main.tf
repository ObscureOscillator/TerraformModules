locals {
  repo_files   = fileset("${path.module}/repos", "*.yaml")
  repositories = merge([
    for f in local.repo_files :
    yamldecode(file("${path.module}/repos/${f}"))
  ]...)
}

module "org_repos" {
  source = "../../modules/github-organization-repos"

  repositories = local.repositories
}
