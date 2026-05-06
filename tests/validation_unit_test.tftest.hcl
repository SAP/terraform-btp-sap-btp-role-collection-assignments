mock_provider "btp" {}

# -----------------------------------------------------------------------------
# Cross-variable validation: at least one list must be non-empty
# -----------------------------------------------------------------------------

run "test_both_lists_empty_fails" {
  command = plan

  variables {
    subaccount_id                        = "00000000-0000-0000-0000-000000000000"
    default_origin_id                    = "sap.default"
    role_collection_assignments_by_group = []
    role_collection_assignments_by_user  = []
  }

  expect_failures = [
    var.role_collection_assignments_by_group,
  ]
}

run "test_only_groups_provided_is_valid" {
  command = plan

  variables {
    subaccount_id     = "00000000-0000-0000-0000-000000000000"
    default_origin_id = "sap.default"
    role_collection_assignments_by_group = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        group_names          = ["viewers"]
      }
    ]
    role_collection_assignments_by_user = []
  }

  assert {
    condition     = length(local.assignments_by_group) == 1
    error_message = "Should create one group assignment"
  }
}

run "test_only_users_provided_is_valid" {
  command = plan

  variables {
    subaccount_id                        = "00000000-0000-0000-0000-000000000000"
    default_origin_id                    = "sap.default"
    role_collection_assignments_by_group = []
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        user_names           = ["alice@example.com"]
      }
    ]
  }

  assert {
    condition     = length(local.assignments_by_user) == 1
    error_message = "Should create one user assignment"
  }
}

run "test_both_groups_and_users_provided_is_valid" {
  command = plan

  variables {
    subaccount_id     = "00000000-0000-0000-0000-000000000000"
    default_origin_id = "sap.default"
    role_collection_assignments_by_group = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        group_names          = ["viewers"]
      }
    ]
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Admin"
        origin_id            = null
        user_names           = ["admin@example.com"]
      }
    ]
  }

  assert {
    condition     = length(local.assignments_by_group) == 1
    error_message = "Should create one group assignment"
  }

  assert {
    condition     = length(local.assignments_by_user) == 1
    error_message = "Should create one user assignment"
  }
}

# -----------------------------------------------------------------------------
# Origin ID validation: by_group
# -----------------------------------------------------------------------------

run "test_group_missing_origin_and_no_default_fails" {
  command = plan

  variables {
    subaccount_id     = "00000000-0000-0000-0000-000000000000"
    default_origin_id = null
    role_collection_assignments_by_group = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        group_names          = ["viewers"]
      }
    ]
    role_collection_assignments_by_user = []
  }

  expect_failures = [
    var.role_collection_assignments_by_group,
  ]
}

run "test_group_with_per_entry_origin_and_no_default_is_valid" {
  command = plan

  variables {
    subaccount_id     = "00000000-0000-0000-0000-000000000000"
    default_origin_id = null
    role_collection_assignments_by_group = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = "sap.custom"
        group_names          = ["viewers"]
      }
    ]
    role_collection_assignments_by_user = []
  }

  assert {
    condition     = local.assignments_by_group["Subaccount_Viewer__viewers__sap_custom"].origin_id == "sap.custom"
    error_message = "Per-entry origin should be used"
  }
}

# -----------------------------------------------------------------------------
# Origin ID validation: by_user
# -----------------------------------------------------------------------------

run "test_user_missing_origin_and_no_default_fails" {
  command = plan

  variables {
    subaccount_id                        = "00000000-0000-0000-0000-000000000000"
    default_origin_id                    = null
    role_collection_assignments_by_group = []
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        user_names           = ["alice@example.com"]
      }
    ]
  }

  expect_failures = [
    var.role_collection_assignments_by_user,
  ]
}

run "test_user_with_per_entry_origin_and_no_default_is_valid" {
  command = plan

  variables {
    subaccount_id                        = "00000000-0000-0000-0000-000000000000"
    default_origin_id                    = null
    role_collection_assignments_by_group = []
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = "sap.custom"
        user_names           = ["alice@example.com"]
      }
    ]
  }

  assert {
    condition     = local.assignments_by_user["Subaccount_Viewer__alice_at_example_com__sap_custom"].origin_id == "sap.custom"
    error_message = "Per-entry origin should be used"
  }
}

# -----------------------------------------------------------------------------
# Default origin fallback
# -----------------------------------------------------------------------------

run "test_default_origin_used_as_fallback" {
  command = plan

  variables {
    subaccount_id     = "00000000-0000-0000-0000-000000000000"
    default_origin_id = "sap.default"
    role_collection_assignments_by_group = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        group_names          = ["viewers"]
      }
    ]
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Admin"
        origin_id            = null
        user_names           = ["bob@example.com"]
      }
    ]
  }

  assert {
    condition     = local.assignments_by_group["Subaccount_Viewer__viewers__sap_default"].origin_id == "sap.default"
    error_message = "Group assignment should fall back to default_origin_id"
  }

  assert {
    condition     = local.assignments_by_user["Subaccount_Admin__bob_at_example_com__sap_default"].origin_id == "sap.default"
    error_message = "User assignment should fall back to default_origin_id"
  }
}

run "test_per_entry_origin_overrides_default" {
  command = plan

  variables {
    subaccount_id     = "00000000-0000-0000-0000-000000000000"
    default_origin_id = "sap.default"
    role_collection_assignments_by_group = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = "sap.custom"
        group_names          = ["viewers"]
      }
    ]
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Admin"
        origin_id            = "sap.custom"
        user_names           = ["carol@example.com"]
      }
    ]
  }

  assert {
    condition     = local.assignments_by_group["Subaccount_Viewer__viewers__sap_custom"].origin_id == "sap.custom"
    error_message = "Per-entry origin should override default for groups"
  }

  assert {
    condition     = local.assignments_by_user["Subaccount_Admin__carol_at_example_com__sap_custom"].origin_id == "sap.custom"
    error_message = "Per-entry origin should override default for users"
  }
}

# -----------------------------------------------------------------------------
# Username key sanitization for special characters
# -----------------------------------------------------------------------------

run "test_username_special_characters_in_keys" {
  command = plan

  variables {
    subaccount_id                        = "00000000-0000-0000-0000-000000000000"
    default_origin_id                    = "sap.default"
    role_collection_assignments_by_group = []
    role_collection_assignments_by_user = [
      {
        role_collection_name = "Subaccount Viewer"
        origin_id            = null
        user_names = [
          "john.doe+test@example.com",
          "simple user",
        ]
      }
    ]
  }

  assert {
    condition     = contains(keys(local.assignments_by_user), "Subaccount_Viewer__john_doe_plus_test_at_example_com__sap_default")
    error_message = "Key should sanitize @, ., and + in email addresses"
  }

  assert {
    condition     = contains(keys(local.assignments_by_user), "Subaccount_Viewer__simple_user__sap_default")
    error_message = "Key should replace spaces with underscores in usernames"
  }

  assert {
    condition     = length(local.assignments_by_user) == 2
    error_message = "Should create two user assignments"
  }
}
