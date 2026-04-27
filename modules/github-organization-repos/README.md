# GitHub Organization Repositories

## References
[github_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository)

## Description
Terraform module for managing GitHub repositories and all their settings within an organization. Repository definitions are loaded from a YAML file for easy day-to-day management — adding, modifying, or removing a repository requires only a YAML edit with no Terraform code changes.

## Usage

### HCL (inline)

```hcl
module "org_repos" {
  source = "./modules/github-organization-repos"

  repositories = {
    "my-service" = {
      description            = "Core API service"
      visibility             = "private"
      has_issues             = true
      delete_branch_on_merge = true
      auto_init              = true
      topics                 = ["go", "api"]
    }
    "my-public-lib" = {
      description  = "Open-source client library"
      visibility   = "public"
      license_template  = "mit"
      gitignore_template = "Go"
      auto_init    = true
    }
  }
}
```

### YAML-driven — one file per repository (recommended)

Store each repository in its own `.yaml` file inside a `repos/` directory. Terraform merges them all at plan time. Adding or removing a repository only requires adding or deleting a file.

```
repos/
├── my-service.yaml
└── my-public-library.yaml
```

```hcl
locals {
  repo_files   = fileset("${path.module}/repos", "*.yaml")
  repositories = merge([
    for f in local.repo_files :
    yamldecode(file("${path.module}/repos/${f}"))
  ]...)
}

module "org_repos" {
  source       = "./modules/github-organization-repos"
  repositories = local.repositories
}
```

```yaml
# repos/my-service.yaml
my-service:
  description: "Core API service"
  visibility: private
  delete_branch_on_merge: true
  auto_init: true
```

## Importing Existing Repositories

Bring an existing repository under Terraform management without recreating it:

```shell
terraform import 'module.org_repos.github_repository.this["my-service"]' my-service
```

After importing, run `terraform plan` to confirm no unintended changes.

---

## `repos.yaml` Schema

Each entry under `repositories:` is keyed by the **repository name** (must be unique within the organization). All fields are optional except where noted.

### General Settings

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `description` | `string` | `""` | Short description shown on the repository page |
| `homepage_url` | `string` | `null` | URL of a page describing the project (shown in the About sidebar) |
| `visibility` | `string` | `"private"` | `public`, `private`, or `internal` (internal requires GitHub Enterprise Cloud) |
| `topics` | `list(string)` | `[]` | Topic labels shown on the repository page; used for discoverability |
| `is_template` | `bool` | `false` | Mark this repository as a template that others can use to generate new repos |
| `archived` | `bool` | `false` | Set to `true` to archive the repository (makes it read-only) |
| `archive_on_destroy` | `bool` | `false` | When `true`, archives the repository on `terraform destroy` instead of deleting it; useful for preserving history |

### Feature Flags

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `has_issues` | `bool` | `true` | Enable GitHub Issues |
| `has_discussions` | `bool` | `false` | Enable GitHub Discussions |
| `has_projects` | `bool` | `false` | Enable GitHub Projects (classic boards) |
| `has_wiki` | `bool` | `false` | Enable GitHub Wiki |

### Initialization Settings

> **Note:** These fields are only applied when a repository is **first created**. The GitHub API ignores them on subsequent updates, so changing them after creation has no effect. If you need to change the default branch, use the `github_branch_default` resource.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `auto_init` | `bool` | `false` | Produce an initial commit with a README when the repository is created. Required when using `gitignore_template` or `license_template` |
| `gitignore_template` | `string` | `null` | Name of a [`.gitignore` template](https://github.com/github/gitignore) to apply (e.g., `Go`, `Python`, `Terraform`). Requires `auto_init: true` |
| `license_template` | `string` | `null` | SPDX license identifier for the LICENSE file (e.g., `mit`, `apache-2.0`, `gpl-3.0`). Requires `auto_init: true` |

### Merge Strategy Settings

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `allow_merge_commit` | `bool` | `true` | Allow merge commits (`git merge --no-ff`) |
| `allow_squash_merge` | `bool` | `true` | Allow squash merging (combines all commits into one) |
| `allow_rebase_merge` | `bool` | `true` | Allow rebase merging (replays commits on top of base branch) |
| `allow_auto_merge` | `bool` | `false` | Allow pull requests to be auto-merged once all required checks pass |
| `allow_forking` | `bool` | `false` | Allow organization members to fork private repositories |
| `allow_update_branch` | `bool` | `false` | Show an "Update branch" button on pull requests that are behind their base branch |
| `delete_branch_on_merge` | `bool` | `false` | Automatically delete the head branch after a pull request is merged |

### Merge Commit Message Configuration

These fields control the default commit title and message for each merge strategy. They are only relevant when the corresponding merge strategy is enabled.

| Field | Type | Default | Allowed Values | Description |
|-------|------|---------|----------------|-------------|
| `squash_merge_commit_title` | `string` | `null` | `PR_TITLE`, `COMMIT_OR_PR_TITLE` | Default title for squash merge commits |
| `squash_merge_commit_message` | `string` | `null` | `PR_BODY`, `COMMIT_MESSAGES`, `BLANK` | Default message for squash merge commits |
| `merge_commit_title` | `string` | `null` | `PR_TITLE`, `MERGE_MESSAGE` | Default title for merge commits |
| `merge_commit_message` | `string` | `null` | `PR_BODY`, `PR_TITLE`, `BLANK` | Default message body for merge commits |

### Security Settings

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `web_commit_signoff_required` | `bool` | `false` | Require contributors to sign off on commits made through the GitHub web UI |
| `vulnerability_alerts` | `bool` | `false` | Enable Dependabot vulnerability alerts for insecure dependencies |

### Template Source (`template`)

Populate this block **only when creating a repository from a template**. Like the initialization fields, this is applied at creation time only.

```yaml
repositories:
  my-new-service:
    description: "New service created from the standard template"
    visibility: private
    template:
      owner: my-org
      repository: service-template
      include_all_branches: false
```

| Field | Type | Required | Default | Description |
|-------|------|:--------:|---------|-------------|
| `owner` | `string` | yes | — | GitHub organization or user that owns the template repository |
| `repository` | `string` | yes | — | Name of the template repository |
| `include_all_branches` | `bool` | no | `false` | Copy all branches from the template, not just the default branch |

### Security and Analysis (`security_and_analysis`)

> **Prerequisite:** `advanced_security` requires a GitHub Advanced Security (GHAS) licence. It is available for free on **public** repositories, and on **private** repositories only with GitHub Enterprise Cloud (GHEC) or GitHub Enterprise Server (GHES).  
> `secret_scanning` and `secret_scanning_push_protection` require `advanced_security: enabled` on private repositories.

```yaml
repositories:
  my-private-service:
    visibility: private
    security_and_analysis:
      advanced_security:
        status: enabled
      secret_scanning:
        status: enabled
      secret_scanning_push_protection:
        status: enabled
```

| Field | Type | Required | Allowed Values | Description |
|-------|------|:--------:|----------------|-------------|
| `advanced_security.status` | `string` | yes (if block present) | `enabled`, `disabled` | Enable or disable GitHub Advanced Security |
| `secret_scanning.status` | `string` | yes (if block present) | `enabled`, `disabled` | Enable or disable secret scanning |
| `secret_scanning_push_protection.status` | `string` | yes (if block present) | `enabled`, `disabled` | Enable or disable push protection (blocks commits containing detected secrets) |

---

## Full YAML Example

```yaml
repositories:

  # ── Public open-source library ─────────────────────────────────────────────
  my-public-library:
    description: "Open-source Terraform modules for GitHub management"
    visibility: public
    homepage_url: "https://my-org.github.io/my-public-library"
    topics:
      - terraform
      - infrastructure-as-code
      - github
    has_issues: true
    has_discussions: true
    has_projects: false
    has_wiki: false
    auto_init: true
    gitignore_template: Terraform
    license_template: apache-2.0
    allow_merge_commit: false
    allow_squash_merge: true
    allow_rebase_merge: false
    squash_merge_commit_title: PR_TITLE
    squash_merge_commit_message: BLANK
    delete_branch_on_merge: true
    allow_update_branch: true
    vulnerability_alerts: true

  # ── Private internal service ────────────────────────────────────────────────
  my-private-service:
    description: "Internal payments microservice"
    visibility: private
    has_issues: true
    has_discussions: false
    has_projects: false
    has_wiki: false
    auto_init: true
    allow_merge_commit: true
    allow_squash_merge: true
    allow_rebase_merge: false
    merge_commit_title: PR_TITLE
    merge_commit_message: PR_BODY
    delete_branch_on_merge: true
    web_commit_signoff_required: true
    vulnerability_alerts: true
    security_and_analysis:
      advanced_security:
        status: enabled
      secret_scanning:
        status: enabled
      secret_scanning_push_protection:
        status: enabled

  # ── Template repository ─────────────────────────────────────────────────────
  service-template:
    description: "Starter template for all new Go microservices"
    visibility: private
    is_template: true
    auto_init: true
    gitignore_template: Go
    license_template: mit
    has_issues: false
    has_wiki: false
    has_projects: false
    delete_branch_on_merge: true

  # ── Repository created from a template ──────────────────────────────────────
  new-service-from-template:
    description: "New service scaffolded from the standard template"
    visibility: private
    template:
      owner: my-org
      repository: service-template
      include_all_branches: false

  # ── Archived legacy repository ───────────────────────────────────────────────
  legacy-monolith:
    description: "Decommissioned monolith — archived for reference"
    visibility: private
    archived: true
    archive_on_destroy: true
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.12 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.12 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of repositories keyed by repository name | See schema above | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_repositories"></a> [repositories](#output\_repositories) | Map of managed repositories keyed by name. Each value contains: `id`, `node_id`, `repo_id`, `full_name`, `html_url`, `ssh_clone_url`, `http_clone_url`, `git_clone_url`, `svn_url` |
<!-- END_TF_DOCS -->
