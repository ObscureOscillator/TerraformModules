# Example: GitHub Organization Repositories

This example demonstrates how to use the `github-organization-repos` module to manage repositories and all their settings within a GitHub organization.

## Overview

Each repository is defined in its own YAML file inside the [`repos/`](repos/) directory. Terraform reads and merges all `.yaml` files from that directory at plan time — no Terraform code changes are needed to add, remove, or reconfigure a repository. Simply add a new `.yaml` file (or delete an existing one) and run `terraform apply`.

## Prerequisites

- Terraform `>= 1.3.0`
- A GitHub organization that already exists
- A GitHub personal access token (classic) with the following scopes:
  - `repo` — required to create and manage repositories
  - `admin:org` — required to manage organization-level repository settings

## Files

| File / Directory | Purpose |
|------------------|---------|
| `versions.tf` | Declares the required Terraform version and GitHub provider version constraint |
| `providers.tf` | Configures the GitHub provider with the target organization and authentication token |
| `variables.tf` | Declares the input variables (`github_token`, `github_organization`) |
| `main.tf` | Reads all YAML files from `repos/` and calls the `github-organization-repos` module |
| `outputs.tf` | Exposes the repositories map as an output |
| `repos/` | One `.yaml` file per repository; each file defines a single repo and all its settings |

## Usage

### 1. Clone the repository

```shell
git clone https://github.com/Jared-Bloomer/TerraformModules.git
cd TerraformModules/examples/github-organization-repos
```

### 2. Add or edit a repository

Create a new file in `repos/` named after the repository:

```shell
touch repos/my-new-service.yaml
```

Populate it with the repository's settings:

```yaml
# repos/my-new-service.yaml
my-new-service:
  description: "My new microservice"
  visibility: private
  has_issues: true
  delete_branch_on_merge: true
  auto_init: true
  topics:
    - go
    - microservice
```

The top-level key (`my-new-service`) is the **repository name** as it will appear in GitHub. It must match across your organization (names must be unique).

To **remove** a repository from management, delete its `.yaml` file. Running `terraform apply` will then destroy (or archive, if `archive_on_destroy: true`) that repository.

### 3. Create a `terraform.tfvars` file

```hcl
github_token        = "ghp_xxxxxxxxxxxxxxxxxxxx"
github_organization = "my-org"
```

Or export as environment variables:

```shell
export TF_VAR_github_token="ghp_xxxxxxxxxxxxxxxxxxxx"
export TF_VAR_github_organization="my-org"
```

### 4. Initialize and apply

```shell
terraform init
terraform plan
terraform apply
```

## `repos/` Directory Structure

```
repos/
├── legacy-monolith.yaml       # Archived legacy repository
├── my-private-service.yaml    # Private internal microservice
├── my-public-library.yaml     # Public open-source library
└── service-template.yaml      # Template repository for new services
```

Each file contains a single top-level key (the repository name) with all its settings as nested fields. See the [module README](../../modules/github-organization-repos/README.md) for the full field reference.

### Minimal example

```yaml
my-simple-repo:
  description: "A simple private repository"
  visibility: private
```

### Full example with all common options

```yaml
my-full-example:
  description: "Example with all settings shown"
  visibility: private
  homepage_url: "https://my-org.example.com/my-full-example"
  topics:
    - go
    - api
  has_issues: true
  has_discussions: false
  has_projects: false
  has_wiki: false
  auto_init: true
  gitignore_template: Go
  license_template: apache-2.0
  allow_merge_commit: true
  allow_squash_merge: true
  allow_rebase_merge: false
  merge_commit_title: PR_TITLE
  merge_commit_message: PR_BODY
  squash_merge_commit_title: PR_TITLE
  squash_merge_commit_message: BLANK
  delete_branch_on_merge: true
  allow_auto_merge: false
  allow_forking: false
  allow_update_branch: true
  web_commit_signoff_required: false
  vulnerability_alerts: true
  security_and_analysis:
    advanced_security:
      status: enabled
    secret_scanning:
      status: enabled
    secret_scanning_push_protection:
      status: enabled
```

## Importing Existing Repositories

Bring an existing repository under Terraform management without recreating it.

1. Add the repository's YAML file in `repos/` with the desired settings.
2. Run the import:

```shell
terraform import 'module.org_repos.github_repository.this["my-existing-repo"]' my-existing-repo
```

3. Run `terraform plan` to confirm no unintended changes, and adjust the YAML if needed.

## Input Variables

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `github_token` | GitHub personal access token with repo and org admin permissions | `string` | yes |
| `github_organization` | The GitHub organization login name (slug) | `string` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `repositories` | Map of all managed repositories. Each entry contains `id`, `node_id`, `repo_id`, `full_name`, `html_url`, `ssh_clone_url`, `http_clone_url`, `git_clone_url`, and `svn_url` |
