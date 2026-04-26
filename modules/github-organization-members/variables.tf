variable "members" {
  description = "Map of organization members keyed by GitHub username"
  type = map(object({
    role                 = optional(string, "member")
    downgrade_on_destroy = optional(bool, false)
  }))
  default = {}

  validation {
    condition     = alltrue([for m in values(var.members) : contains(["member", "admin"], m.role)])
    error_message = "Each member role must be either \"member\" or \"admin\"."
  }
}
