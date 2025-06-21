resource "random_password" "bazarr_api_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

resource "random_password" "bazarr_flask_secret_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

module "bazarr_api_key" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/bazarr"
  secret_data = {
    api_key = random_password.bazarr_api_key.result,
    flask_secret_key = random_password.bazarr_flask_secret_key.result,
  }
}
