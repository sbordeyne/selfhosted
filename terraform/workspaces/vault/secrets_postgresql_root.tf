resource "random_password" "postgresql_root_password" {
  length  = 32
}
resource "random_password" "postgresql_user_password" {
  length  = 32
}
resource "random_password" "postgresql_replication_password" {
  length  = 32
}


module "postgresql_root_credentials" {
  source = "../../modules/vault-secret"

  secret_path = "databases/postgresql/root"
  secret_data = {
    postgresql_user = "postgres"
    postgresql_password = random_password.postgresql_root_password.result
    user_password  = random_password.postgresql_user_password.result
    replication_password = random_password.postgresql_replication_password.result
  }
}
