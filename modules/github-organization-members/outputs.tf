output "members" {
  description = "Map of managed organization members with their role and resource ID"
  value = {
    for username, membership in github_membership.this :
    username => {
      id   = membership.id
      role = membership.role
      etag = membership.etag
    }
  }
}
