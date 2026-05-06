terraform {
  required_version = ">= 1.14"

  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.22.0"
    }
  }
}
