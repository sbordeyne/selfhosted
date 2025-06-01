terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.0.0"
    }
  }
}

variable "service_account_name" {
  description = ""
  type        = string
}
variable "service_account_namespace" {
  description = ""
  type        = string
}
variable "secret_access" {
  description = "Map of secret paths to access levels"
  type        = map(string)
}

locals {
  role_name = "${var.service_account_namespace}-${var.service_account_name}"
  policies = [for path, access in var.secret_access : "${replace(path, "/", "-")}-${access}"]
}

data "vault_auth_backend" "kubernetes" {
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_role" "role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = local.role_name
  bound_service_account_names      = [var.service_account_name]
  bound_service_account_namespaces = [var.service_account_namespace]
  token_ttl                        = 3600
  token_policies                   = local.policies
}
