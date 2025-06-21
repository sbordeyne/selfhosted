terraform {
  required_version = ">= 1.8.0"

  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.25.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "postgresql" {
  host = try(var.postgresql.host, "localhost")
  port = try(var.postgresql.port, 5432)
  username = try(var.postgresql.username, "postgres")
  password = var.postgresql.password
}

provider "vault" {
  address = "http://vault.vault.svc.cluster.local:8200"
  skip_tls_verify = true
  token   = var.vault_token
}
