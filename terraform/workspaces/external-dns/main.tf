terraform {}

module "vault-access" {
  source = "../../modules/vault-access"

  service_account_name   = "external-dns"
  service_account_namespace = "operators"
  secret_access = {
    "external-dns/txt-encrypt" = "reader",
    "cloudflare/credentials" = "reader",
  }
}
