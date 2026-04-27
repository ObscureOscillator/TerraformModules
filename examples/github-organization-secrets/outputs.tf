output "secrets" {
  description = "Map of managed organization secrets with metadata"
  sensitive   = true
  value       = module.org_secrets.secrets
}
