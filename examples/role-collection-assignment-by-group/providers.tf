provider "btp" {
  globalaccount = var.globalaccount_subdomain
  idp           = var.idp
  # Optionally, you can specify credentials here or rely on environment variables or other authentication methods supported by the BTP provider
}
