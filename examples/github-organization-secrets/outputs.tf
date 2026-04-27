output "secrets" {
  description = "Map of managed organization secrets with metadata"
  value = module.org_secrets.secrets
}
