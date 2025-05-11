locals {
  databases = {
    for dbname, dbdata in var.databases:
      dbname => {
        user     = dbdata.user
        database = dbname
      }
  }
}

resource "random_password" "password" {
  for_each = local.databases
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "postgresql_role" "roles" {
  for_each = local.databases

  name     = each.value.user
  password = random_password.password[each.key].result
  login = true
}

resource "postgresql_database" "databases" {
  for_each = local.databases

  name     = each.value.database
  owner    = each.value.user
}

data "vault_mount" "databases_kvv2" {
  path = "databases"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "database_secret" {
  for_each = local.databases
  mount                      = data.vault_mount.databases_kvv2.path
  name                       = "postgresql/${each.key}"
  cas                        = 1
  delete_all_versions        = false
  data_json                  = jsonencode(
    {
      username       = each.value.user,
      password       = random_password.password[each.key].result
    }
  )
}
