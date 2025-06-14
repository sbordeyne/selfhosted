vault_access = {
  "external-dns" = {
    service_account = "external-dns"
    namespace       = "operators"
    access = {
      "external-dns/txt-encrypt" = "reader"
      "cloudflare/credentials"   = "reader"
    }
  },
  "cert-manager" = {
    service_account = "cert-manager"
    namespace       = "cert-manager"
    access = {
      "cloudflare/credentials"   = "reader"
    }
  },
  "cloudflare-ddns" = {
    service_account = "cloudflare-ddns"
    namespace       = "cloudflare-ddns"
    access = {
      "cloudflare/credentials"   = "reader"
    }
  }
}
