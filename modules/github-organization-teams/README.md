# Github Organization Teams

## References
[github_team](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team)
[github_team_membership](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_membership)

## Description
Terraform Module for managing GitHub Organization teams and team membership.

## Usage

```hcl
module "org_teams" {
  source = "./modules/github-organization-teams"

  teams = {
    "platform" = {
      description = "Platform engineering team"
      privacy     = "closed"
      members = {
        "octocat"  = "member"
        "monalisa" = "maintainer"
      }
    }
    "security" = {
      description = "Security team"
      privacy     = "secret"
      members = {
        "monalisa" = "maintainer"
      }
    }
  }
}
```

Teams can also be loaded from a `teams.yaml` file using Terraform's built-in `yamldecode`:

```hcl
locals {
  teams_config = yamldecode(file("${path.module}/teams.yaml"))
}

module "org_teams" {
  source = "./modules/github-organization-teams"
  teams  = local.teams_config.teams
}
```

## Importing Existing Teams

Import a team using its numeric GitHub team ID:

```shell
terraform import 'module.org_teams.github_team.this["platform"]' 1234567
```

Import a team membership using `<team_id>:<username>`:

```shell
terraform import 'module.org_teams.github_team_membership.this["platform:octocat"]' 1234567:octocat
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
| [github_team.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team) | resource |
| [github_team_membership.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_teams"></a> [teams](#input\_teams) | Map of teams keyed by team name | <pre>map(object({<br/>    description = optional(string, "")<br/>    privacy     = optional(string, "closed")<br/>    members     = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_team_memberships"></a> [team\_memberships](#output\_team\_memberships) | Map of team memberships keyed by "team\_name:username" |
| <a name="output_teams"></a> [teams](#output\_teams) | Map of managed teams with their ID, slug, and node ID |
<!-- END_TF_DOCS -->
