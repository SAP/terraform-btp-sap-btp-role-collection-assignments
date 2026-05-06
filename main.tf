locals {
  assignments_by_group = {
    for entry in flatten([
      for rc in var.role_collection_assignments_by_group : [
        for group in rc.group_names : {
          role_collection_name = rc.role_collection_name
          group_name           = group
          origin_id            = coalesce(rc.origin_id, var.default_origin_id)
          key                  = "${replace(rc.role_collection_name, " ", "_")}__${replace(group, " ", "_")}__${replace(coalesce(rc.origin_id, var.default_origin_id), ".", "_")}"
        }
      ]
    ]) : entry.key => entry
  }

  assignments_by_user = {
    for entry in flatten([
      for rc in var.role_collection_assignments_by_user : [
        for user in rc.user_names : {
          role_collection_name = rc.role_collection_name
          user_name            = user
          origin_id            = coalesce(rc.origin_id, var.default_origin_id)
          key                  = "${replace(rc.role_collection_name, " ", "_")}__${replace(replace(replace(replace(user, " ", "_"), "@", "_at_"), ".", "_"), "+", "_plus_")}__${replace(coalesce(rc.origin_id, var.default_origin_id), ".", "_")}"
        }
      ]
    ]) : entry.key => entry
  }
}

resource "btp_subaccount_role_collection_assignment" "by_group" {
  for_each = local.assignments_by_group

  subaccount_id        = var.subaccount_id
  role_collection_name = each.value.role_collection_name
  group_name           = each.value.group_name
  origin               = each.value.origin_id
}

resource "btp_subaccount_role_collection_assignment" "by_user" {
  for_each = local.assignments_by_user

  subaccount_id        = var.subaccount_id
  role_collection_name = each.value.role_collection_name
  user_name            = each.value.user_name
  origin               = each.value.origin_id
}
