terraform {}

variable "vault_address" {
  description = "Vault server address"
  type        = string
}
variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true
}

module "vault-access" {
  for_each = yamldecode(file("${path.module}/data/vault-access.yaml"))

  source = "../../modules/vault-access"

  vault = {
    address = var.vault_address
    token   = var.vault_token
  }

  service_account_name   = each.value.service_account
  service_account_namespace = each.value.namespace
  secret_access = each.value.access
}
