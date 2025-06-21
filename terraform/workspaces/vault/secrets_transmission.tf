resource "random_password" "transmission_password" {
  length  = 32
}

module "transmission_credentials" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/transmission"
  secret_data = {
    username = "transmission",
    password = random_password.transmission_password.result,
  }
}
