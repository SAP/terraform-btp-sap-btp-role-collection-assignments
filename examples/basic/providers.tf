terraform {
  required_version = ">= 1.0.0"

  required_providers {
    btp = {
      source  = "SAP/btp"
      version = ">= 1.0.0"
    }
  }
}

# Provider configuration
# Authentication is done via environment variables:
#   - BTP_USERNAME
#   - BTP_PASSWORD
#   - BTP_GLOBALACCOUNT
provider "btp" {}
