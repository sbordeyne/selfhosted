resource "random_password" "prowlarr_api_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

module "prowlarr_api_key" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/prowlarr"
  secret_data = {
    api_key = random_password.prowlarr_api_key.result
  }
}
