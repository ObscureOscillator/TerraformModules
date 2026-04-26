# Example: GitHub Organization Members

This example demonstrates how to use the `github-organization-members` module to manage the membership of an existing GitHub organization on github.com.

## Overview

The `github-organization-members` module manages GitHub organization membership through the [`github_membership`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership) resource. It does **not** create the organization itself — the organization must already exist in GitHub. Members are declared as a map keyed by GitHub username, making additions, removals, and role changes explicit and diff-friendly.

## Prerequisites

- Terraform `>= 1.3.0`
- A GitHub organization that already exists
- A GitHub personal access token (classic) with the following scopes:
  - `admin:org` — required to manage organization membership

## Files

| File | Purpose |
|------|---------|
| `versions.tf` | Declares the required Terraform version and the GitHub provider version constraint |
| `providers.tf` | Configures the GitHub provider with the target organization and authentication token |
| `variables.tf` | Declares the input variables for this example (`github_token`, `github_organization`) |
| `main.tf` | Calls the `github-organization-members` module with a sample member roster |
| `outputs.tf` | Exposes the full members map as an output |

## Usage

### 1. Clone the repository

```shell
git clone https://github.com/Jared-Bloomer/TerraformModules.git
cd TerraformModules/examples/github-organization-members
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

Members are declared as a map where each key is the GitHub username and the value is an object with the following fields:

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `role` | `string` | `"member"` | The user's role in the organization. Must be `member` or `admin` |
| `downgrade_on_destroy` | `bool` | `false` | When `true`, demotes the user to a regular member on destroy instead of removing them from the org entirely |

```hcl
members = {
  "octocat" = {
    role = "member"
  }
  "hubot" = {
    role                 = "admin"
    downgrade_on_destroy = true
  }
}
```

> **Note:** Each map key must be the exact GitHub username (case-sensitive) as it appears in the user's GitHub profile URL (e.g. `github.com/octocat`).

## Importing Existing Members

If your organization already has members you want to bring under Terraform management, import them before running `apply`. The import address uses the `for_each` key (the GitHub username):

```shell
terraform import 'module.org_members.github_membership.this["octocat"]' my-org:octocat
```

Repeat for each existing member, then run `terraform plan` to confirm no unintended changes.

## Outputs

| Name | Description |
|------|-------------|
| `members` | Map of all managed members. Each entry contains `id`, `role`, and `etag` |

## Minimal Example

Only the username key is required. The role defaults to `member` and `downgrade_on_destroy` defaults to `false`.

```hcl
module "org_members" {
  source = "../../modules/github-organization-members"

  members = {
    "octocat" = {}
  }
}
```
