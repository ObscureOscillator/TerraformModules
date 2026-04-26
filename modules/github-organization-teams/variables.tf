variable "teams" {
  description = "Map of teams keyed by team name"
  type = map(object({
    description = optional(string, "")
    privacy     = optional(string, "closed")
    members     = optional(map(string), {})
  }))
  default = {}

  validation {
    condition     = alltrue([for t in values(var.teams) : contains(["closed", "secret"], t.privacy)])
    error_message = "Each team privacy must be either \"closed\" or \"secret\"."
  }

  validation {
    condition = alltrue(flatten([
      for t in values(var.teams) : [
        for role in values(t.members) : contains(["member", "maintainer"], role)
      ]
    ]))
    error_message = "Each team member role must be either \"member\" or \"maintainer\"."
  }
}
