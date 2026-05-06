# Role Collection Assignment by Group

This example demonstrates how to assign SAP BTP role collections to multiple groups using the `rolecollection` module.

It creates multiple role collection assignments across different groups, including an override of the default identity provider origin for a specific assignment.

## Usage

```terraform
module "rc_assignment" {
  source = "../../."

  subaccount_id    = "5cb53b0d-a5fc-44db-955e-9a72488fed74"
  default_origin_id = "sap.default"

  role_collection_assignments_by_group = [
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
```

## Prerequisites

- Terraform >= 1.14
- SAP BTP provider >= 1.22.0
- A valid SAP BTP globalaccount and subaccount
- SAP BTP credentials configured via environment variables or provider arguments

## Running This Example

1. Provide a `terraform.tfvars` file with your own values for `globalaccount_subdomain`, `idp`, and `subaccount_id`.

2. Initialize, plan, and apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14 |
| <a name="requirement_btp"></a> [btp](#requirement\_btp) | ~> 1.22.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_rc_assignment"></a> [rc\_assignment](#module\_rc\_assignment) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_default_origin_id"></a> [default\_origin\_id](#input\_default\_origin\_id) | The default origin ID used when no specific origin ID is provided in a role collection assignment. | `string` | `"sap.default"` | no |
| <a name="input_globalaccount_subdomain"></a> [globalaccount\_subdomain](#input\_globalaccount\_subdomain) | The global account subdomain. | `string` | n/a | yes |
| <a name="input_idp"></a> [idp](#input\_idp) | The identity provider (IDP) to use for authentication with the BTP provider. | `string` | n/a | yes |
| <a name="input_role_collection_assignments_by_group"></a> [role\_collection\_assignments\_by\_group](#input\_role\_collection\_assignments\_by\_group) | List of role collection assignments. Each entry defines a role collection and the groups to assign to it. | <pre>list(object({<br/>    role_collection_name = string<br/>    origin_id            = optional(string)<br/>    group_names          = list(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "group_names": [<br/>      "Test Group 1",<br/>      "Test Group 2"<br/>    ],<br/>    "role_collection_name": "Subaccount Viewer"<br/>  },<br/>  {<br/>    "group_names": [<br/>      "Test Group 4",<br/>      "Test Group 6"<br/>    ],<br/>    "role_collection_name": "Destination Administrator"<br/>  },<br/>  {<br/>    "group_names": [<br/>      "Test Group 3"<br/>    ],<br/>    "origin_id": "terraformeds-platform",<br/>    "role_collection_name": "Destination Fragment Administrator"<br/>  }<br/>]</pre> | no |
| <a name="input_subaccount_id"></a> [subaccount\_id](#input\_subaccount\_id) | The ID of the subaccount. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_assignments_count"></a> [assignments\_count](#output\_assignments\_count) | The number of role collection assignments that have been made using the group attribute. |
| <a name="output_assignments_keys"></a> [assignments\_keys](#output\_assignments\_keys) | The list of keys identifying each role collection assignment that have been made using the group attribute. |
<!-- END_TF_DOCS -->
