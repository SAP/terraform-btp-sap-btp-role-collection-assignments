output "assignments_count" {
  description = "The number of role collection assignments that have been made using the user attribute."
  value       = module.rc_assignment.assignments_by_user_count
}

output "assignments_keys" {
  description = "The list of keys identifying each role collection assignment that have been made using the user attribute."
  value       = module.rc_assignment.assignments_by_user_keys
}
