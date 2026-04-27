output "secrets" {
  description = "Map of managed organization secrets keyed by secret name"
  value = {
    for name, secret in github_actions_organization_secret.this :
    name => {
      id         = secret.id
      created_at = secret.created_at
      updated_at = secret.updated_at
      visibility = secret.visibility
    }
  }
}
