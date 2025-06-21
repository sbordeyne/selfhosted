resource "random_password" "radarr_api_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

module "radarr_api_key" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/radarr"
  secret_data = {
    api_key = random_password.radarr_api_key.result
  }
}
