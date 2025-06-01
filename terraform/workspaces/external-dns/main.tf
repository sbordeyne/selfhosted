terraform {}

variable "vault" {
  description = "Vault configuration"
  type = object({
    address = string
    token   = string
  })
}

module "vault-access" {
  source = "../../modules/vault-access"

  vault = var.vault

  service_account_name   = "external-dns"
  service_account_namespace = "operators"
  secret_access = {
    "external-dns/txt-encrypt" = "reader",
    "cloudflare/credentials" = "reader",
  }
}
