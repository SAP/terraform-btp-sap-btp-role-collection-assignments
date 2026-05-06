variable "subaccount_id" {
  description = "The ID of the subaccount."
  type        = string
}

variable "role_collection_assignments_by_group" {
  description = "List of role collection assignments. Each entry defines a role collection and the groups to assign to it."
  type = list(object({
    role_collection_name = string
    origin_id            = optional(string)
    group_names          = list(string)
  }))
  default = []

  validation {
    condition     = length(var.role_collection_assignments_by_group) > 0 || length(var.role_collection_assignments_by_user) > 0
    error_message = "At least one of 'role_collection_assignments_by_group' or 'role_collection_assignments_by_user' must be provided and non-empty."
  }

  validation {
    condition = alltrue([
      for rc in var.role_collection_assignments_by_group : rc.origin_id != null
    ]) || var.default_origin_id != null || length(var.role_collection_assignments_by_group) == 0
    error_message = "Either every role collection assignment by group name must have an origin_id, or default_origin_id must be provided."
  }
}

variable "role_collection_assignments_by_user" {
  description = "List of role collection assignments. Each entry defines a role collection and the users to assign to it."
  type = list(object({
    role_collection_name = string
    origin_id            = optional(string)
    user_names           = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rc in var.role_collection_assignments_by_user : rc.origin_id != null
    ]) || var.default_origin_id != null || length(var.role_collection_assignments_by_user) == 0
    error_message = "Either every role collection assignment by user name must have an origin_id, or default_origin_id must be provided."
  }
}

variable "default_origin_id" {
  description = "The default origin ID used when no specific origin ID is provided in a role collection assignment."
  type        = string
  default     = null
}
