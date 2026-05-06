[![REUSE status](https://api.reuse.software/badge/github.com/SAP/terraform-module-repository-template)](https://api.reuse.software/info/github.com/SAP/terraform-module-repository-template)

# Terraform Module for Role Collection Assignments on SAP BTP

This module manages [role collection assignments](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_role_collection_assignment) on SAP BTPat the subaccount level.

## Motivation

The SAP BTP Terraform provider resource `btp_subaccount_role_collection_assignment` assigns a single role collection to exactly one user or one group per resource instance. In practice, organizations need to assign multiple role collections to multiple groups and users, which leads to repetitive and error-prone configurations:

```terraform
resource "btp_subaccount_role_collection_assignment" "viewer_group_a" {
  subaccount_id        = var.subaccount_id
  role_collection_name = "Subaccount Viewer"
  group_name           = "Group A"
  origin               = "sap.default"
}

resource "btp_subaccount_role_collection_assignment" "viewer_group_b" {
  subaccount_id        = var.subaccount_id
  role_collection_name = "Subaccount Viewer"
  group_name           = "Group B"
  origin               = "sap.default"
}

# ... and so on for every combination
```

This module eliminates that boilerplate. You provide a list of role collections, each with its associated groups or users, and the module flattens these into individual `for_each`-managed resources. Composite keys derived from the role collection name, the assignee, and the identity provider origin ensure **stable resource addresses** — reordering or extending the input lists does not cause unintended drift or resource re-creation.

## Usage

### Assign role collections to groups

```terraform
module "role_collection_assignment" {
  source  = "lechnerc77/rolecollection/btp"
  version = "1.0.0"

  subaccount_id     = "5cb53b0d-a5fc-44db-955e-9a72488fed74"
  default_origin_id = "sap.default"

  role_collection_assignments_by_group = [
    {
      role_collection_name = "Subaccount Viewer"
      group_names          = ["Platform Viewers", "Auditors"]
    },
    {
      role_collection_name = "Subaccount Administrator"
      group_names          = ["Platform Admins"]
    },
    {
      role_collection_name = "Destination Administrator"
      origin_id            = "sap.custom"
      group_names          = ["Integration Team"]
    }
  ]
}
```

### Assign role collections to users

```terraform
module "role_collection_assignment" {
  source  = "lechnerc77/rolecollection/btp"
  version = "1.0.0"

  subaccount_id     = "5cb53b0d-a5fc-44db-955e-9a72488fed74"
  default_origin_id = "sap.default"

  role_collection_assignments_by_user = [
    {
      role_collection_name = "Subaccount Administrator"
      user_names           = ["alice@example.com", "bob@example.com"]
    },
    {
      role_collection_name = "Connectivity and Destination Administrator"
      origin_id            = "sap.custom"
      user_names           = ["carol@example.com"]
    }
  ]
}
```

### Origin handling

Each assignment entry supports an optional `origin_id` that overrides `default_origin_id` for that specific entry. If neither is set, the module's validation will fail, ensuring that every assignment has a defined identity provider origin.

## Examples

- [Role collection assignment by group](examples/role-collection-assignment-by-group)
- [Role collection assignment by user](examples/role-collection-assignment-by-user)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.14 |
| <a name="requirement_btp"></a> [btp](#requirement\_btp) | ~>1.21.3 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_btp"></a> [btp](#provider\_btp) | 1.21.3 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [btp_subaccount_role_collection_assignment.by_group](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_role_collection_assignment) | resource |
| [btp_subaccount_role_collection_assignment.by_user](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_role_collection_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_default_origin_id"></a> [default\_origin\_id](#input\_default\_origin\_id) | The default origin ID used when no specific origin ID is provided in a role collection assignment. | `string` | `null` | no |
| <a name="input_role_collection_assignments_by_group"></a> [role\_collection\_assignments\_by\_group](#input\_role\_collection\_assignments\_by\_group) | List of role collection assignments. Each entry defines a role collection and the groups to assign to it. | <pre>list(object({<br/>    role_collection_name = string<br/>    origin_id            = optional(string)<br/>    group_names          = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_role_collection_assignments_by_user"></a> [role\_collection\_assignments\_by\_user](#input\_role\_collection\_assignments\_by\_user) | List of role collection assignments. Each entry defines a role collection and the users to assign to it. | <pre>list(object({<br/>    role_collection_name = string<br/>    origin_id            = optional(string)<br/>    user_names           = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_subaccount_id"></a> [subaccount\_id](#input\_subaccount\_id) | The ID of the subaccount. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_assignments_by_group_count"></a> [assignments\_by\_group\_count](#output\_assignments\_by\_group\_count) | The number of role collection assignments that have been made using the group attribute. |
| <a name="output_assignments_by_group_keys"></a> [assignments\_by\_group\_keys](#output\_assignments\_by\_group\_keys) | The list of keys identifying each role collection assignment that have been made using the group attribute. |
| <a name="output_assignments_by_user_count"></a> [assignments\_by\_user\_count](#output\_assignments\_by\_user\_count) | The number of role collection assignments that have been made using the user attribute. |
| <a name="output_assignments_by_user_keys"></a> [assignments\_by\_user\_keys](#output\_assignments\_by\_user\_keys) | The list of keys identifying each role collection assignment that have been made using the user attribute. |
<!-- END_TF_DOCS -->

## Contributing

Contributions are welcome. Please run the following checks before submitting a pull request:

```bash
terraform fmt -recursive
terraform validate
terraform test
```

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.
