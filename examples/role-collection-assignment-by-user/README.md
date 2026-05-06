# Role Collection Assignment by User

This example demonstrates how to assign SAP BTP role collections to multiple users using the `rolecollection` module.

It creates multiple role collection assignments across different users, including an override of the default identity provider origin for a specific assignment.

## Usage

```terraform
module "rc_assignment" {
  source = "../../."

  subaccount_id     = "5cb53b0d-a5fc-44db-955e-9a72488fed74"
  default_origin_id = "sap.default"

  role_collection_assignments_by_user = [
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
| <a name="input_role_collection_assignments_by_user"></a> [role\_collection\_assignments\_by\_user](#input\_role\_collection\_assignments\_by\_user) | List of role collection assignments. Each entry defines a role collection and the users to assign to it. | <pre>list(object({<br/>    role_collection_name = string<br/>    origin_id            = optional(string)<br/>    user_names           = list(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "role_collection_name": "Subaccount Viewer",<br/>    "user_names": [<br/>      "john.doe@example.com",<br/>      "jane.doe@example.com"<br/>    ]<br/>  },<br/>  {<br/>    "role_collection_name": "Destination Administrator",<br/>    "user_names": [<br/>      "bob.doe@example.com",<br/>      "alice.doe@example.com"<br/>    ]<br/>  },<br/>  {<br/>    "origin_id": "terraformeds-platform",<br/>    "role_collection_name": "Destination Fragment Administrator",<br/>    "user_names": [<br/>      "charlie.doe@example.com"<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_subaccount_id"></a> [subaccount\_id](#input\_subaccount\_id) | The ID of the subaccount. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_assignments_count"></a> [assignments\_count](#output\_assignments\_count) | The number of role collection assignments that have been made using the user attribute. |
| <a name="output_assignments_keys"></a> [assignments\_keys](#output\_assignments\_keys) | The list of keys identifying each role collection assignment that have been made using the user attribute. |
<!-- END_TF_DOCS -->
