variable "vault_address" {
  description = "Vault server address"
  type        = string
}
variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true
}
provider "vault" {
  address = var.vault.address
  token   = var.vault.token
}
