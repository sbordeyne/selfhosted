terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.0.0"
    }
  }
}

import {
  to   = vault_auth_backend.kubernetes
  id = "kubernetes"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_role" "roles" {
  for_each = yamldecode(file("./terraform/workspaces/vault/data/vault-roles.yaml"))

  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${each.value.namespace}-${each.value.service_account}"
  bound_service_account_names      = [each.value.service_account]
  bound_service_account_namespaces = [each.value.namespace]
  token_ttl                        = 3600
  token_policies                   = [for path, access in each.value.access : "${replace(path, "/", "-")}-${access}"]
}
