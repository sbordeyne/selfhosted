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
