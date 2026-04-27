resource "github_repository" "this" {
  for_each = var.repositories

  name         = each.key
  description  = each.value.description
  homepage_url = each.value.homepage_url
  visibility   = each.value.visibility
  topics       = each.value.topics
  is_template  = each.value.is_template
  archived     = each.value.archived
  archive_on_destroy = each.value.archive_on_destroy

  has_issues      = each.value.has_issues
  has_discussions = each.value.has_discussions
  has_projects    = each.value.has_projects
  has_wiki        = each.value.has_wiki

  # Only meaningful at creation time; ignored on updates by the provider
  auto_init          = each.value.auto_init
  gitignore_template = each.value.gitignore_template
  license_template   = each.value.license_template

  allow_merge_commit  = each.value.allow_merge_commit
  allow_squash_merge  = each.value.allow_squash_merge
  allow_rebase_merge  = each.value.allow_rebase_merge
  allow_auto_merge    = each.value.allow_auto_merge
  allow_forking       = each.value.allow_forking
  allow_update_branch = each.value.allow_update_branch

  squash_merge_commit_title   = each.value.squash_merge_commit_title
  squash_merge_commit_message = each.value.squash_merge_commit_message
  merge_commit_title          = each.value.merge_commit_title
  merge_commit_message        = each.value.merge_commit_message

  delete_branch_on_merge      = each.value.delete_branch_on_merge
  web_commit_signoff_required = each.value.web_commit_signoff_required
  vulnerability_alerts        = each.value.vulnerability_alerts

  dynamic "pages" {
    for_each = each.value.pages != null ? [each.value.pages] : []
    content {
      build_type = pages.value.build_type
      cname      = pages.value.cname
      dynamic "source" {
        for_each = pages.value.source != null ? [pages.value.source] : []
        content {
          branch = source.value.branch
          path   = source.value.path
        }
      }
    }
  }

  dynamic "template" {
    for_each = each.value.template != null ? [each.value.template] : []
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = template.value.include_all_branches
    }
  }

  dynamic "security_and_analysis" {
    for_each = each.value.security_and_analysis != null ? [each.value.security_and_analysis] : []
    content {
      dynamic "advanced_security" {
        for_each = security_and_analysis.value.advanced_security != null ? [security_and_analysis.value.advanced_security] : []
        content {
          status = advanced_security.value.status
        }
      }

      dynamic "secret_scanning" {
        for_each = security_and_analysis.value.secret_scanning != null ? [security_and_analysis.value.secret_scanning] : []
        content {
          status = secret_scanning.value.status
        }
      }

      dynamic "secret_scanning_push_protection" {
        for_each = security_and_analysis.value.secret_scanning_push_protection != null ? [security_and_analysis.value.secret_scanning_push_protection] : []
        content {
          status = secret_scanning_push_protection.value.status
        }
      }
    }
  }
}
