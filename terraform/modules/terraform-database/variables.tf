variable "databases" {
  description = "Databases to create"
  type        = map(object({
    user = string
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
