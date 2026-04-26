# Github Organization Members

## References
[Terraform Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership)

## Description
Terraform Module for managing GitHub Organization membership.

## Usage

```hcl
module "org_members" {
  source = "./modules/github-organization-members"

  members = {
    "octocat" = {
      role = "member"
    }
    "monalisa" = {
      role                 = "admin"
      downgrade_on_destroy = true
    }
  }
}
```

## Importing Existing Members

Each membership can be imported using `<org>:<username>`:

```shell
terraform import 'module.org_members.github_membership.this["octocat"]' myorg:octocat
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
| [github_membership.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_members"></a> [members](#input\_members) | Map of organization members keyed by GitHub username | <pre>map(object({<br/>    role                 = optional(string, "member")<br/>    downgrade_on_destroy = optional(bool, false)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_members"></a> [members](#output\_members) | Map of managed organization members with their role and resource ID |
<!-- END_TF_DOCS -->
