data "google_kms_secret" "kms_secret" {
  crypto_key = local.key_name
  ciphertext = local.mysql_password_ciphertext
}

module "mysql_password" {
 source           = "./modules/secret"
 project_id       = local.project_id
 secret_id        = var.mysql_password_secret_id
 secret_data      = local.mysql_password
 secret_accessors = [local.service_account]
}

