locals {
  databases = {
    for data in flatten([
        for user, data in var.users : [
          for db in data.databases: [
            {
              database = db
              user     = user
              key     = "${user}-${db}"
            }
          ]
        ]
    ]): data.key => {
      database  = data.database
      owner     = data.user
    }
  }
}

resource "random_password" "password" {
  for_each = var.users
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "postgresql_role" "roles" {
  for_each = var.users

  name     = each.key
  password = random_password.password[each.key].result
  login = true
}

resource "postgresql_database" "databases" {
  for_each = local.databases

  name     = each.value.database
  owner    = each.value.owner
}

module "secret" {
  for_each = var.users
  source = "../vault-secret"

  secret_data = {
    username = each.key,
    password = random_password.password[each.key].result,
    host           = var.postgresql.host,
    port           = tostring(var.postgresql.port),
  }
  secret_path = "postgresql/${each.key}"
}
