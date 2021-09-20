locals {
  project_id         = var.project_id
  secret_id          = var.secret_id
  kms_crypto_key     = var.kms_crypto_key
  secret_data        = var.secret_data
  secret_data_cypher = var.secret_data_cypher
  secret_accessors   = var.secret_accessors

  secret = local.secret_data_cypher == "" ? local.secret_data : data.google_kms_secret.kms_secret[0].plaintext
}

data "google_kms_secret" "kms_secret" {
  count      = local.kms_crypto_key == "" ? 0 : 1
  crypto_key = local.kms_crypto_key
  ciphertext = local.secret_data_cypher
}

resource "google_secret_manager_secret" "secret" {
  project   = local.project_id
  secret_id = local.secret_id
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = local.secret
}

resource "google_secret_manager_secret_iam_binding" "secret_iam_binding" {
  project   = google_secret_manager_secret.secret.project
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = local.secret_accessors
}
