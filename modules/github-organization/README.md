# Github Organization

## References
[Terraform Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs)

## Description
Terraform Module for managing a Github Organization

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
| [github_organization_settings.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_organization"></a> [organization](#input\_organization) | Configuration for the GitHub organization | <pre>object({<br/>    billing_email = string<br/>    display_name  = optional(string)<br/>    description   = optional(string, "")<br/><br/>    profile = optional(object({<br/>      company          = optional(string)<br/>      blog             = optional(string)<br/>      email            = optional(string)<br/>      twitter_username = optional(string)<br/>      location         = optional(string)<br/>    }), {})<br/><br/>    projects = optional(object({<br/>      has_organization_projects     = optional(bool, true)<br/>      has_repository_projects       = optional(bool, true)<br/>      default_repository_permission = optional(string, "read")<br/>    }), {})<br/><br/>    member_permissions = optional(object({<br/>      members_can_create_repositories          = optional(bool, true)<br/>      members_can_create_public_repositories   = optional(bool, true)<br/>      members_can_create_private_repositories  = optional(bool, true)<br/>      members_can_create_internal_repositories = optional(bool, false)<br/>      members_can_create_pages                 = optional(bool, true)<br/>      members_can_create_public_pages          = optional(bool, true)<br/>      members_can_create_private_pages         = optional(bool, true)<br/>      members_can_fork_private_repositories    = optional(bool, false)<br/>      web_commit_signoff_required              = optional(bool, false)<br/>    }), {})<br/><br/>    security = optional(object({<br/>      advanced_security_enabled_for_new_repositories               = optional(bool, false)<br/>      dependabot_alerts_enabled_for_new_repositories               = optional(bool, false)<br/>      dependabot_security_updates_enabled_for_new_repositories     = optional(bool, false)<br/>      dependency_graph_enabled_for_new_repositories                = optional(bool, false)<br/>      secret_scanning_enabled_for_new_repositories                 = optional(bool, false)<br/>      secret_scanning_push_protection_enabled_for_new_repositories = optional(bool, false)<br/>    }), {})<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_organization_settings_id"></a> [organization\_settings\_id](#output\_organization\_settings\_id) | The ID of the organization settings resource |
<!-- END_TF_DOCS -->