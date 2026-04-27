resource "github_actions_organization_secret" "this" {
  for_each = var.secrets

  secret_name             = each.key
  visibility              = each.value.visibility
  plaintext_value         = each.value.plaintext_value
  selected_repository_ids = each.value.visibility == "selected" ? each.value.selected_repository_ids : []
}
