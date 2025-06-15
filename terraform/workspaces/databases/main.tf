data "vault_kv_secret_v2" "postgres" {
  mount = "databases"
  name  = "postgresql/root"
}


module "database" {
  source = "../../modules/terraform-database"

  postgresql = {
    host = "192.168.1.42"
    port = 5432
    username = data.vault_kv_secret_v2.postgres.data.username
    password = data.vault_kv_secret_v2.postgres.data.password
  }

  databases = {
    "keycloak" = {
      user = "keycloak"
      accessors = [
        {
          service_account = "keycloak"
          namespace = "keycloak"
        }
      ]
    }
  }
}
