variable "vault_access" {
  description = "Access control for Vault secrets"
  type = map(object({
    service_account = string,
    namespace       = string,
    access = map(string) # Maps path to access level (e.g., "reader", "writer")
  }))
}
