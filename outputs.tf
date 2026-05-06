output "assignments_by_group_count" {
  description = "The number of role collection assignments that have been made using the group attribute."
  value       = length(local.assignments_by_group)
}

output "assignments_by_group_keys" {
  description = "The list of keys identifying each role collection assignment that have been made using the group attribute."
  value       = keys(local.assignments_by_group)
}

output "assignments_by_user_count" {
  description = "The number of role collection assignments that have been made using the user attribute."
  value       = length(local.assignments_by_user)
}

output "assignments_by_user_keys" {
  description = "The list of keys identifying each role collection assignment that have been made using the user attribute."
  value       = keys(local.assignments_by_user)
}
