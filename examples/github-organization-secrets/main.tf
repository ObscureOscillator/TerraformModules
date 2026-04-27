module "org_secrets" {
  source = "../../modules/github-organization-secrets"

  secrets = var.secrets
}
