// Cloud Storage Bucket for Application content 
resource "google_storage_bucket" "images_store" {
  name          = "${var.gcs_backend_name}-${local.project_id}"
  project       = var.project_id
  storage_class = var.storage_class
  location      = var.bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.images_store.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}