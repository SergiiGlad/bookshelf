output "secret_id" {
  value       = google_secret_manager_secret.secret.id
  description = "Secret Manager secret projects/{{project}}/secrets/{{secret_id}}"
}

output "secret_name" {
  value       = google_secret_manager_secret.secret.secret_id
  description = "Secret Manager secret {{secret_id}}"
}

output "secret_version" {
  value       = google_secret_manager_secret_version.secret_version.name
  description = "Secret Manager secret version projects/{{project}}/secrets/{{secret_id}}/versions/{{version}}"
}

output "secret_data" {
  value       = google_secret_manager_secret_version.secret_version.secret_data
  description = "The secret data"
  sensitive   = true
}
