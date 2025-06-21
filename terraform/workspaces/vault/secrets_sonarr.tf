resource "random_password" "sonarr_api_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

module "sonarr_api_key" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/sonarr"
  secret_data = {
    api_key = random_password.sonarr_api_key.result
  }
}
