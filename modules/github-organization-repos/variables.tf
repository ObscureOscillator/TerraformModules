variable "repositories" {
  description = "Map of repositories keyed by repository name"
  type = map(object({

    # ── General ─────────────────────────────────────────────────────────────
    description  = optional(string, "")
    homepage_url = optional(string)
    # visibility: "public", "private", or "internal" (enterprise only)
    visibility = optional(string, "private")
    # topics: list of topic labels shown on the repository page
    topics      = optional(list(string), [])
    is_template = optional(bool, false)
    archived    = optional(bool, false)
    # archive_on_destroy: when true, archives the repo instead of deleting it
    archive_on_destroy = optional(bool, false)

    # ── Features ─────────────────────────────────────────────────────────────
    has_issues      = optional(bool, true)
    has_discussions = optional(bool, false)
    has_projects    = optional(bool, false)
    has_wiki        = optional(bool, false)

    # ── Initialization (applied at creation only; ignored on updates) ────────
    auto_init          = optional(bool, false)
    gitignore_template = optional(string)
    license_template   = optional(string)

    # ── Merge strategies ─────────────────────────────────────────────────────
    allow_merge_commit  = optional(bool, true)
    allow_squash_merge  = optional(bool, true)
    allow_rebase_merge  = optional(bool, true)
    allow_auto_merge    = optional(bool, false)
    allow_forking       = optional(bool, false)
    # allow_update_branch: show "Update branch" button on PRs when behind base
    allow_update_branch = optional(bool, false)

    # ── Merge commit message configuration ───────────────────────────────────
    # squash_merge_commit_title: "PR_TITLE" or "COMMIT_OR_PR_TITLE"
    squash_merge_commit_title = optional(string)
    # squash_merge_commit_message: "PR_BODY", "COMMIT_MESSAGES", or "BLANK"
    squash_merge_commit_message = optional(string)
    # merge_commit_title: "PR_TITLE" or "MERGE_MESSAGE"
    merge_commit_title = optional(string)
    # merge_commit_message: "PR_BODY", "PR_TITLE", or "BLANK"
    merge_commit_message = optional(string)

    delete_branch_on_merge      = optional(bool, false)
    web_commit_signoff_required = optional(bool, false)

    # ── Security ─────────────────────────────────────────────────────────────
    # vulnerability_alerts: enable Dependabot alerts for vulnerable dependencies
    vulnerability_alerts = optional(bool, false)

    # ── Pages ────────────────────────────────────────────────────────────────
    # Omit this block entirely to disable GitHub Pages for the repository.
    # build_type: "legacy" (branch-based) or "workflow" (GitHub Actions-driven)
    # source is only used when build_type = "legacy"
    pages = optional(object({
      build_type = optional(string, "legacy")
      cname      = optional(string)
      source = optional(object({
        branch = string
        path   = optional(string, "/")
      }))
    }))

    # ── Team access ──────────────────────────────────────────────────────────
    # Map of team slug -> permission level.
    # Valid permissions: "pull", "triage", "push", "maintain", "admin"
    teams = optional(map(string), {})

    # ── Environments ─────────────────────────────────────────────────────────
    # Map of environment name -> configuration.
    environments = optional(map(object({
      # wait_timer: minutes to wait before allowing deployments (0–43200)
      wait_timer          = optional(number, 0)
      can_admins_bypass   = optional(bool, true)
      prevent_self_review = optional(bool, false)
      # reviewers: up to 6 combined teams + users who must approve deployments
      reviewers = optional(object({
        teams = optional(list(string), [])
        users = optional(list(string), [])
      }))
      # deployment_branch_policy: restrict which branches can deploy to this env
      deployment_branch_policy = optional(object({
        protected_branches     = bool
        custom_branch_policies = bool
      }))
    })), {})

    # ── Template source ──────────────────────────────────────────────────────
    # Populate only when creating a repository from a template.
    # template.owner and template.repository identify the template repo.
    template = optional(object({
      owner                = string
      repository           = string
      include_all_branches = optional(bool, false)
    }))

    # ── Security and analysis (GitHub Advanced Security) ─────────────────────
    # advanced_security requires a GHAS licence (public repos or GHEC/GHES).
    # secret_scanning and secret_scanning_push_protection require advanced_security
    # to be enabled on private repositories.
    security_and_analysis = optional(object({
      advanced_security = optional(object({
        # status: "enabled" or "disabled"
        status = string
      }))
      secret_scanning = optional(object({
        # status: "enabled" or "disabled"
        status = string
      }))
      secret_scanning_push_protection = optional(object({
        # status: "enabled" or "disabled"
        status = string
      }))
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      contains(["public", "private", "internal"], r.visibility)
    ])
    error_message = "Each repository visibility must be \"public\", \"private\", or \"internal\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.squash_merge_commit_title == null ||
      contains(["PR_TITLE", "COMMIT_OR_PR_TITLE"], r.squash_merge_commit_title)
    ])
    error_message = "squash_merge_commit_title must be \"PR_TITLE\" or \"COMMIT_OR_PR_TITLE\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.squash_merge_commit_message == null ||
      contains(["PR_BODY", "COMMIT_MESSAGES", "BLANK"], r.squash_merge_commit_message)
    ])
    error_message = "squash_merge_commit_message must be \"PR_BODY\", \"COMMIT_MESSAGES\", or \"BLANK\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.merge_commit_title == null ||
      contains(["PR_TITLE", "MERGE_MESSAGE"], r.merge_commit_title)
    ])
    error_message = "merge_commit_title must be \"PR_TITLE\" or \"MERGE_MESSAGE\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.merge_commit_message == null ||
      contains(["PR_BODY", "PR_TITLE", "BLANK"], r.merge_commit_message)
    ])
    error_message = "merge_commit_message must be \"PR_BODY\", \"PR_TITLE\", or \"BLANK\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.pages == null || contains(["legacy", "workflow"], r.pages.build_type)
    ])
    error_message = "pages.build_type must be \"legacy\" or \"workflow\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      alltrue([
        for permission in values(coalesce(r.teams, {})) :
        contains(["pull", "triage", "push", "maintain", "admin"], permission)
      ])
    ])
    error_message = "Team permission must be one of: \"pull\", \"triage\", \"push\", \"maintain\", \"admin\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.security_and_analysis == null ||
      r.security_and_analysis.advanced_security == null ||
      contains(["enabled", "disabled"], r.security_and_analysis.advanced_security.status)
    ])
    error_message = "security_and_analysis.advanced_security.status must be \"enabled\" or \"disabled\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.security_and_analysis == null ||
      r.security_and_analysis.secret_scanning == null ||
      contains(["enabled", "disabled"], r.security_and_analysis.secret_scanning.status)
    ])
    error_message = "security_and_analysis.secret_scanning.status must be \"enabled\" or \"disabled\"."
  }

  validation {
    condition = alltrue([
      for r in values(var.repositories) :
      r.security_and_analysis == null ||
      r.security_and_analysis.secret_scanning_push_protection == null ||
      contains(["enabled", "disabled"], r.security_and_analysis.secret_scanning_push_protection.status)
    ])
    error_message = "security_and_analysis.secret_scanning_push_protection.status must be \"enabled\" or \"disabled\"."
  }
}
