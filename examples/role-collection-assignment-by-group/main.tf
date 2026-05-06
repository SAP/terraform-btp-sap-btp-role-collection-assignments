module "rc_assignment" {
  source                               = "../.."
  subaccount_id                        = var.subaccount_id
  default_origin_id                    = var.default_origin_id
  role_collection_assignments_by_group = var.role_collection_assignments_by_group
}
