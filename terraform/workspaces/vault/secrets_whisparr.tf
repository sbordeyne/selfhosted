resource "random_password" "whisparr_api_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

module "whisparr_api_key" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/whisparr"
  secret_data = {
    api_key = random_password.whisparr_api_key.result
  }
}
