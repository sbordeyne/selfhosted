vault_access = {
  "external-dns" = {
    service_account = "external-dns"
    namespace       = "operators"
    access = {
      "external-dns/txt-encrypt" = "reader"
      "cloudflare/credentials"   = "reader"
    }
  }
}
