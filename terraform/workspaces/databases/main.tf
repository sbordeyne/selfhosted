terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.0.0"
    }
  }
}

provider "vault" {
  address        = "http://vault.vault.svc.cluster.local:8200"
  skip_tls_verify = true
  token          = var.vault_token
}

variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true
}

data "vault_kv_secret_v2" "postgres" {
  mount = "databases"
  name  = "postgresql/root"
}


module "database" {
  source = "../../modules/terraform-database"

  postgresql = {
    host = "192.168.1.42"
    port = 5432
    username = data.vault_kv_secret_v2.postgres.data.username
    password = data.vault_kv_secret_v2.postgres.data.password
  }

  vault_token = var.vault_token

  users = {
    "keycloak" = {
      databases = ["keycloak"]
    },
    "sonarr" = {
      databases = ["sonarr", "sonarr_log"]
    },
    "radarr" = {
      databases = ["radarr", "radarr_log"]
    },
    "readarr" = {
      databases = ["readarr", "readarr_log"]
    },
    "prowlarr" = {
      databases = ["prowlarr", "prowlarr_log"]
    },
    "whisparr" = {
      databases = ["whisparr", "whisparr_log"]
    },
    "bazarr" = {
      databases = ["bazarr", "bazarr_log"]
    },
    "sonarr" = {
      databases = ["sonarr", "sonarr_log"]
    },
    "sonarr" = {
      databases = ["sonarr", "sonarr_log"]
    }
  }
}
