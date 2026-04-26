# Example: GitHub Organization Teams

This example demonstrates how to use the `github-organization-teams` module to manage teams and their membership in an existing GitHub organization.

## Overview

Teams and members are declared in [`teams.yaml`](teams.yaml). The example reads and decodes that file at plan time using Terraform's built-in `yamldecode` function, then passes the result to the module. Editing the YAML file is the only change needed to add, remove, or reconfigure teams and their members.

## Prerequisites

- Terraform `>= 1.3.0`
- A GitHub organization that already exists
- A GitHub personal access token (classic) with the following scopes:
  - `admin:org` — required to manage organization teams and membership

## Files

| File | Purpose |
|------|---------|
| `versions.tf` | Declares the required Terraform version and the GitHub provider version constraint |
| `providers.tf` | Configures the GitHub provider with the target organization and authentication token |
| `variables.tf` | Declares the input variables for this example (`github_token`, `github_organization`) |
| `teams.yaml` | Declares all teams, their settings, and member rosters |
| `main.tf` | Decodes `teams.yaml` and calls the `github-organization-teams` module |
| `outputs.tf` | Exposes the teams and membership maps as outputs |

## Usage

### 1. Clone the repository

```shell
git clone https://github.com/Jared-Bloomer/TerraformModules.git
cd TerraformModules/examples/github-organization-teams
```

### 2. Edit `teams.yaml`

Add, remove, or modify teams and members directly in `teams.yaml`:

```yaml
teams:
  platform:
    description: "Platform engineering team"
    privacy: closed
    members:
      octocat: member
      monalisa: maintainer
```

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

## `teams.yaml` Schema

Each entry under `teams:` is keyed by the team display name. All fields except the key are optional.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `description` | `string` | `""` | Human-readable description shown in the GitHub UI |
| `privacy` | `string` | `"closed"` | `closed` — visible to all org members; `secret` — visible only to team members |
| `members` | `map(string)` | `{}` | Map of `username: role`. Role must be `member` or `maintainer` |

```yaml
teams:
  # Minimal — all defaults apply
  frontend: {}

  # Full configuration
  platform:
    description: "Platform engineering team"
    privacy: closed
    members:
      octocat: member       # can interact with team resources
      monalisa: maintainer  # can manage team membership and settings
```

## Input Variables

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `github_token` | GitHub personal access token with org admin permissions | `string` | yes |
| `github_organization` | The GitHub organization login name (slug) | `string` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `teams` | Map of all managed teams. Each entry contains `id`, `slug`, and `node_id` |
| `team_memberships` | Map of all memberships keyed by `team_name:username`. Each entry contains `id`, `role`, and `etag` |

## Importing Existing Teams

Bring existing GitHub teams and memberships under Terraform management without recreating them.

Import a team using its numeric GitHub ID:

```shell
terraform import 'module.org_teams.github_team.this["platform"]' 1234567
```

Import a team membership:

```shell
terraform import 'module.org_teams.github_team_membership.this["platform:octocat"]' 1234567:octocat
```

After importing, run `terraform plan` to confirm no unintended changes.
