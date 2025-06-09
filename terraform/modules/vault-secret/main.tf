terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.0.0"
    }
  }
}

variable "secret_path" {
  description = "Path to the secret in Vault"
  type      = string
}

variable "secret_data" {
  description = "Data to be stored in the secret"
  type        = map(any)
}

variable "secret_metadata" {
  description = "Metadata for the secret"
  type        = map(string)
  default     = {}
}

resource "vault_policy" "secret_accessor" {
  for_each = {
    "reader" = "[\"read\", \"list\"]",
    "writer"  = "[\"create\", \"update\"]",
    "admin"  = "[\"read\", \"create\", \"update\", \"delete\", \"list\"]",
  }
  name = "${replace(var.secret_path, "/", "-")}-${each.key}"
  policy = <<EOT
path "secrets/data/${var.secret_path}" {
  capabilities = ${each.value}
}
EOT
}

resource "vault_kv_secret_v2" "secret" {
  mount = "secrets"
  name = var.secret_path
  data_json = jsonencode(var.secret_data)

  custom_metadata {
    data = var.secret_metadata
  }
}
