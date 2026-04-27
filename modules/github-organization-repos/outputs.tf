output "repositories" {
  description = "Map of managed repositories keyed by name, containing key metadata and clone URLs"
  value = {
    for name, repo in github_repository.this :
    name => {
      id             = repo.id
      node_id        = repo.node_id
      repo_id        = repo.repo_id
      full_name      = repo.full_name
      html_url       = repo.html_url
      ssh_clone_url  = repo.ssh_clone_url
      http_clone_url = repo.http_clone_url
      git_clone_url  = repo.git_clone_url
      svn_url        = repo.svn_url
    }
  }
}
