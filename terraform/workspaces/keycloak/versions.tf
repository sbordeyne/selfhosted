terraform {
  required_version = ">~ 1.8.0"
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
      version = "4.4.0"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.keycloak_admin_username
  password  = var.keycloak_admin_password
  url       = "http://keycloak.keycloak.svc.cluster.local:8080"
}
