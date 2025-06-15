variable "keycloak_admin_password" {
  description = "Keycloak admin password"
  type        = string
  sensitive   = true
}

variable "keycloak_admin_username" {
  description = "Keycloak admin username"
  type        = string
  sensitive   = false
}
