locals {
  databases = {
    for dbname, dbdata in var.databases:
      dbname => {
        user     = dbdata.user
        database = dbname
        accessors = [
          for accessor in dbdata.accessors:
            {
              service_account = accessor.service_account
              namespace       = accessor.namespace
            }
        ]
        role_name = "secret-accessor-${dbname}"
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

data "vault_auth_backend" "kubernetes" {
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_role" "secret_access" {
  for_each = local.databases
  backend                          = data.vault_auth_backend.kubernetes.path
  role_name                        = each.value.role_name
  bound_service_account_names      = [for accessor in each.value.accessors : accessor.service_account]
  bound_service_account_namespaces = [for accessor in each.value.accessors : accessor.namespace]
  token_ttl                        = 3600
}
