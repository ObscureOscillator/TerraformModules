# TerraformModules

A collection of reusable Terraform modules for managing infrastructure and SaaS platforms. Each module is self-contained, versioned, and designed to be consumed directly via a local path or a Git source reference.

## Repository Structure

```
TerraformModules/
├── modules/                           # Reusable Terraform modules
│   ├── github-organization/           # Manage a GitHub organization's settings
│   └── github-organization-members/   # Manage GitHub organization membership
└── examples/                          # Standalone example projects for each module
    ├── github-organization/           # Full usage example for the github-organization module
    └── github-organization-members/   # Full usage example for the github-organization-members module
```

## Modules

### [`github-organization`](modules/github-organization/)

Manages the settings of an existing GitHub organization on github.com using the [`github_organization_settings`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings) resource.

**Manages:**
- Organization profile (display name, description, website, location)
- Project board enablement and default repository permissions
- Member permissions (repository creation, Pages publishing, forking)
- Security defaults for new repositories (Dependabot, secret scanning, dependency graph)

**Does not manage:** organization creation, teams, repositories, or rulesets.

| Attribute | Value |
|-----------|-------|
| Provider | `integrations/github ~> 6.12` |
| Terraform | `>= 1.3.0` |
| Example | [examples/github-organization](examples/github-organization/) |

### [`github-organization-members`](modules/github-organization-members/)

Manages the membership of an existing GitHub organization using the [`github_membership`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership) resource. Members are declared as a map keyed by GitHub username, making additions, removals, and role changes explicit and diff-friendly.

**Manages:**
- Organization membership (adding and removing members)
- Member roles (`member` or `admin`)
- Destroy behavior (remove vs. downgrade to `member`)

**Does not manage:** organization creation, teams, repositories, or invitations.

| Attribute | Value |
|-----------|-------|
| Provider | `integrations/github ~> 6.12` |
| Terraform | `>= 1.3.0` |
| Example | [examples/github-organization-members](examples/github-organization-members/) |

## Examples

Each example under [`examples/`](examples/) is a fully working Terraform root module that demonstrates real-world usage of the corresponding module. They are intended as a reference — copy and adapt them rather than using them directly.

| Example | Module | Description |
|---------|--------|-------------|
| [github-organization](examples/github-organization/) | `github-organization` | Configures all organization settings including profile, member permissions, and security defaults |
| [github-organization-members](examples/github-organization-members/) | `github-organization-members` | Manages a roster of organization members with per-user roles and destroy behavior |

## Dependency Management

Provider version updates are automated by [Renovate](https://docs.renovatebot.com/). Minor and patch releases auto-merge; major version bumps require manual review. See [`renovate.json`](renovate.json) for the full policy.

## Contributing

1. Add new modules under `modules/<module-name>/`.
2. Include a corresponding example under `examples/<module-name>/`.
3. Each module must have a `versions.tf` using pessimistic version constraints (`~>`), a `variables.tf`, and a `README.md`.
