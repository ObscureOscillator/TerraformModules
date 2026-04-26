# Example: GitHub Organization

This example demonstrates how to use the `github-organization` module to manage the settings of an existing GitHub organization on github.com.

## Overview

The `github-organization` module manages an existing GitHub organization's settings through the [`github_organization_settings`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings) resource. It does **not** create the organization itself — the organization must already exist in GitHub. All configuration is passed through a single `organization` input variable structured into logical sub-objects.

## Prerequisites

- Terraform `>= 1.3.0`
- A GitHub organization that already exists
- A GitHub personal access token (classic) with the following scopes:
  - `admin:org` — required to read and write organization settings

## Files

| File | Purpose |
|------|---------|
| `versions.tf` | Declares the required Terraform version and the GitHub provider version constraint |
| `providers.tf` | Configures the GitHub provider with the target organization and authentication token |
| `variables.tf` | Declares the input variables for this example (`github_token`, `github_organization`) |
| `main.tf` | Calls the `github-organization` module with a full example configuration |
| `outputs.tf` | Exposes the organization settings resource ID as an output |

## Usage

### 1. Clone the repository

```shell
git clone https://github.com/Jared-Bloomer/TerraformModules.git
cd TerraformModules/examples/github-organization
```

### 2. Create a `terraform.tfvars` file

Create a `terraform.tfvars` file to supply the required variables. Do **not** commit this file to version control as it contains a sensitive token.

```hcl
github_token        = "ghp_xxxxxxxxxxxxxxxxxxxx"
github_organization = "my-org"
```

Alternatively, you can pass variables at the command line:

```shell
terraform apply \
  -var="github_token=ghp_xxxxxxxxxxxxxxxxxxxx" \
  -var="github_organization=my-org"
```

Or export them as environment variables (the GitHub provider also reads `GITHUB_TOKEN` natively):

```shell
export TF_VAR_github_token="ghp_xxxxxxxxxxxxxxxxxxxx"
export TF_VAR_github_organization="my-org"
```

### 3. Initialize and apply

```shell
terraform init
terraform plan
terraform apply
```

## Input Variables

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `github_token` | GitHub personal access token with org admin permissions | `string` | yes |
| `github_organization` | The GitHub organization login name (slug) | `string` | yes |

## Module Configuration

The `organization` object passed to the module is broken into five sections. All sections except the top-level fields are optional — omitting a section leaves those settings at their existing values in GitHub.

### Top-Level Fields

These fields directly map to the core `github_organization_settings` resource arguments.

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `billing_email` | `string` | yes | The billing contact email for the organization |
| `display_name` | `string` | no | The human-readable display name shown on the org profile |
| `description` | `string` | no | A short description of the organization (defaults to `""`) |

```hcl
organization = {
  billing_email = "billing@example.com"
  display_name  = "Example Organization"
  description   = "An example GitHub organization managed by Terraform"
  ...
}
```

### `profile`

Controls the public-facing profile information shown on the organization's GitHub page. All fields are optional.

| Field | Type | Description |
|-------|------|-------------|
| `company` | `string` | Company name displayed on the org profile |
| `blog` | `string` | URL to the organization's website or blog |
| `email` | `string` | Public contact email address |
| `twitter_username` | `string` | Twitter/X handle (without the `@`) |
| `location` | `string` | Geographic location displayed on the profile |

```hcl
profile = {
  company  = "Example Corp"
  blog     = "https://example.com"
  email    = "hello@example.com"
  location = "Earth"
}
```

### `projects`

Controls whether GitHub Projects are enabled at the organization and repository level, and what the default base permission is for organization members across all repositories.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `has_organization_projects` | `bool` | `true` | Enable organization-level Projects boards |
| `has_repository_projects` | `bool` | `true` | Enable Projects boards on repositories |
| `default_repository_permission` | `string` | `"read"` | Base permission for members on all org repos. Must be one of `read`, `write`, `admin`, or `none` |

```hcl
projects = {
  has_organization_projects     = true
  has_repository_projects       = true
  default_repository_permission = "read"
}
```

### `member_permissions`

Controls what organization members are allowed to do. These settings are additive on top of the `default_repository_permission` — they restrict or expand specific actions for all members.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `members_can_create_repositories` | `bool` | `true` | Allow members to create any repository |
| `members_can_create_public_repositories` | `bool` | `true` | Allow members to create public repositories |
| `members_can_create_private_repositories` | `bool` | `true` | Allow members to create private repositories |
| `members_can_create_internal_repositories` | `bool` | `false` | Allow members to create internal repositories (Enterprise only) |
| `members_can_create_pages` | `bool` | `true` | Allow members to publish GitHub Pages sites |
| `members_can_create_public_pages` | `bool` | `true` | Allow members to publish public GitHub Pages sites |
| `members_can_create_private_pages` | `bool` | `true` | Allow members to publish private GitHub Pages sites |
| `members_can_fork_private_repositories` | `bool` | `false` | Allow members to fork private repositories within the org |
| `web_commit_signoff_required` | `bool` | `false` | Require a DCO sign-off on commits made through the GitHub web UI |

```hcl
member_permissions = {
  members_can_create_repositories          = true
  members_can_create_public_repositories   = false
  members_can_create_private_repositories  = true
  members_can_create_internal_repositories = false
  members_can_create_pages                 = true
  members_can_create_public_pages          = false
  members_can_create_private_pages         = true
  members_can_fork_private_repositories    = false
  web_commit_signoff_required              = true
}
```

### `security`

Controls which security features are automatically enabled on **newly created** repositories within the organization. Changing these settings does not retroactively affect existing repositories.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `advanced_security_enabled_for_new_repositories` | `bool` | `false` | Enable GitHub Advanced Security on new repos (requires GHAS license) |
| `dependabot_alerts_enabled_for_new_repositories` | `bool` | `false` | Enable Dependabot vulnerability alerts on new repos |
| `dependabot_security_updates_enabled_for_new_repositories` | `bool` | `false` | Enable automatic Dependabot security PRs on new repos |
| `dependency_graph_enabled_for_new_repositories` | `bool` | `false` | Enable the dependency graph on new repos |
| `secret_scanning_enabled_for_new_repositories` | `bool` | `false` | Enable secret scanning on new repos (requires GHAS license) |
| `secret_scanning_push_protection_enabled_for_new_repositories` | `bool` | `false` | Block pushes containing detected secrets on new repos (requires GHAS license) |

```hcl
security = {
  advanced_security_enabled_for_new_repositories               = false
  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true
}
```

> **Note:** `secret_scanning_*` and `advanced_security_*` settings require a GitHub Advanced Security (GHAS) license. Enabling them without a license will result in an API error.

## Outputs

| Name | Description |
|------|-------------|
| `organization_settings_id` | The ID of the `github_organization_settings` resource |

## Minimal Example

Only `billing_email` is required. All other fields fall back to the module's defaults, leaving the rest of the organization's settings unchanged.

```hcl
module "github_organization" {
  source = "../../modules/github-organization"

  organization = {
    billing_email = "billing@example.com"
  }
}
```
