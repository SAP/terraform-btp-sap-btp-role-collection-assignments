# Basic Example

This example demonstrates the basic usage of the module.

## Prerequisites

- Terraform >= 1.0.0
- SAP BTP global account with administrator access
- SAP BTP credentials (username, password, global account subdomain)

## Usage

1. Set environment variables for authentication:

```bash
export BTP_USERNAME="your-username"
export BTP_PASSWORD="your-password"
export BTP_GLOBALACCOUNT="your-global-account-subdomain"
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

See `terraform.tfvars.example` for example values.

## Outputs

After applying, the module will output relevant resource information.
