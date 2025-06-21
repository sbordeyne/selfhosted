resource "random_password" "github_receiver_token" {
  length  = 32
}

module "github_repository_deploy_key" {
  source = "../../modules/vault-secret"

  secret_path = "github/receiver_token"
  secret_data = {
    token = random_password.github_receiver_token.result
  }
}
