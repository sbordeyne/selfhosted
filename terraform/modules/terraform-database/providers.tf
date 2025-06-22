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
      version = "3.7.2"
    }
  }
}

provider "postgresql" {
  host = try(var.postgresql.host, "localhost")
  port = try(var.postgresql.port, 5432)
  username = try(var.postgresql.username, "postgres")
  password = var.postgresql.password
  sslmode = "disable"
}

provider "vault" {
  address = var.vault_address
  skip_tls_verify = true
  token   = var.vault_token
}
