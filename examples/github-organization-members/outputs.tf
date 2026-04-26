output "members" {
  description = "Map of managed organization members with their role and resource ID"
  value       = module.org_members.members
}
