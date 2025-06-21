variable "users" {
  description = "Users and databases to create"
  type        = map(object({
    databases = list(string)
  }))
  sensitive = false
}

variable "postgresql" {
  description = "PostgreSQL settings"
  type        = object({
    host     = string
    port     = number
    username = string
    password = string
  })
  sensitive = true
}

variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true
}

variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = "http://vault.vault.svc.cluster.local:8200"
}
