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
| [github_actions_organization_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of Actions organization secrets keyed by secret name | <pre>map(object({<br/>    # visibility: which repositories can access this secret<br/>    # "all"      - all repositories in the organization<br/>    # "private"  - all private repositories in the organization<br/>    # "selected" - only the repositories listed in selected_repository_ids<br/>    visibility = string<br/><br/>    # plaintext_value: the secret value; encrypted by the provider before storage<br/>    plaintext_value = string<br/><br/>    # selected_repository_ids: repository IDs that may access this secret.<br/>    # Required when visibility = "selected"; ignored otherwise.<br/>    selected_repository_ids = optional(list(number), [])<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | Map of managed organization secrets keyed by secret name |
<!-- END_TF_DOCS -->