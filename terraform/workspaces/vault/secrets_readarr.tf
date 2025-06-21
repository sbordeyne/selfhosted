resource "random_password" "readarr_api_key" {
  length  = 32
  upper = false
  lower = true
  numeric = true
  special = false
}

module "readarr_api_key" {
  source = "../../modules/vault-secret"

  secret_path = "arr-stack/readarr"
  secret_data = {
    api_key = random_password.readarr_api_key.result
  }
}
