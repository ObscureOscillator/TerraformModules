output "repositories" {
  description = "Map of managed repositories with key metadata and clone URLs"
  value       = module.org_repos.repositories
}
