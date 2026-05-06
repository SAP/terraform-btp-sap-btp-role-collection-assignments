variable "globalaccount_subdomain" {
  description = "The global account subdomain."
  type        = string
}

variable "idp" {
  description = "The identity provider (IDP) to use for authentication with the BTP provider."
  type        = string
}

variable "subaccount_id" {
  description = "The ID of the subaccount."
  type        = string
}

variable "default_origin_id" {
  description = "The default origin ID used when no specific origin ID is provided in a role collection assignment."
  type        = string
  default     = "sap.default"
}

variable "role_collection_assignments_by_group" {
  description = "List of role collection assignments. Each entry defines a role collection and the groups to assign to it."
  type = list(object({
    role_collection_name = string
    origin_id            = optional(string)
    group_names          = list(string)
  }))
  default = [
    {
      role_collection_name = "Subaccount Viewer"
      group_names          = ["Test Group 1", "Test Group 2"]
    },
    {
      role_collection_name = "Destination Administrator"
      group_names          = ["Test Group 4", "Test Group 6"]
    },
    {
      role_collection_name = "Destination Fragment Administrator"
      origin_id            = "terraformeds-platform"
      group_names          = ["Test Group 3"]
    }
  ]
}
