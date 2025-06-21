terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "5.0.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
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
  depends_on = [
    module.github_repository_deploy_key,
    module.radarr_api_key,
    module.prowlarr_api_key,
    module.bazarr_api_key,
    module.sonarr_api_key,
    module.readarr_api_key,
    module.whisparr_api_key,
  ]
  for_each = var.vault_access

  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${each.value.namespace}-${each.value.service_account}"
  bound_service_account_names      = [each.value.service_account]
  bound_service_account_namespaces = [each.value.namespace]
  token_ttl                        = 3600
  token_policies                   = [for path, access in each.value.access : "${replace(path, "/", "-")}-${access}"]
}
