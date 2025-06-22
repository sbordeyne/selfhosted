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
  },
  "flux-receiver" = {
    service_account = "notification-controller"
    namespace       = "flux-system"
    access = {
      "github/receiver_token" = "reader"
    }
  },
  "radarr" = {
    service_account = "radarr"
    namespace       = "arr-stack"
    access = {
      "arr-stack/radarr" = "reader",
      "postgresql/radarr" = "reader"
    }
  },
  "sonarr" = {
    service_account = "sonarr"
    namespace       = "arr-stack"
    access = {
      "arr-stack/sonarr" = "reader"
      "postgresql/sonarr" = "reader"
    }
  },
  "readarr" = {
    service_account = "readarr"
    namespace       = "arr-stack"
    access = {
      "arr-stack/readarr" = "reader"
      "postgresql/readarr" = "reader"
    }
  },
  "prowlarr" = {
    service_account = "prowlarr"
    namespace       = "arr-stack"
    access = {
      "arr-stack/prowlarr" = "reader"
      "postgresql/prowlarr" = "reader"
    }
  },
  "whisparr" = {
    service_account = "whisparr"
    namespace       = "arr-stack"
    access = {
      "arr-stack/whisparr" = "reader"
      "postgresql/whisparr" = "reader"
    }
  },
  "bazarr" = {
    service_account = "bazarr"
    namespace       = "arr-stack"
    access = {
      "arr-stack/bazarr" = "reader",
      "arr-stack/sonarr" = "reader",
      "arr-stack/radarr" = "reader",
      "postgresql/bazarr" = "reader",
      "anticaptcha/credentials" = "reader",
    }
  },
  "transmission" = {
    service_account = "transmission"
    namespace       = "arr-stack"
    access = {
      "arr-stack/transmission" = "reader",
    }
  },
  "postgres" = {
    service_account = "postgresql"
    namespace       = "databases"
    access = {
      "databases/postgresql/root" = "reader",
    }
  }
}
