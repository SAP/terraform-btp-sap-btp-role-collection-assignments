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

variable "role_collection_assignments_by_user" {
  description = "List of role collection assignments. Each entry defines a role collection and the users to assign to it."
  type = list(object({
    role_collection_name = string
    origin_id            = optional(string)
    user_names           = list(string)
  }))
  //Note using example.com according to RFC 2606 reserved domain for email addresses in examples
  default = [
    {
      role_collection_name = "Subaccount Viewer"
      user_names           = ["john.doe@example.com", "jane.doe@example.com"]
    },
    {
      role_collection_name = "Destination Administrator"
      user_names           = ["bob.doe@example.com", "alice.doe@example.com"]
    },
    {
      role_collection_name = "Destination Fragment Administrator"
      origin_id            = "terraformeds-platform"
      user_names           = ["charlie.doe@example.com"]

    }
  ]
}
