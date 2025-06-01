terraform {}

variable "vault_address" {
  description = "Vault server address"
  type        = string
}
variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive = true
}

module "vault-access" {
  source = "../../modules/vault-access"

  vault = {
    address = var.vault_address
    token   = var.vault_token
  }

  service_account_name   = "external-dns"
  service_account_namespace = "operators"
  secret_access = {
    "external-dns/txt-encrypt" = "reader",
    "cloudflare/credentials" = "reader",
  }
}
