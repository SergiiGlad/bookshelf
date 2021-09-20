provider "google" {
  project = var.project_id
}

terraform {
  backend "gcs" {
    bucket = "polished-citron-326213-tfstate"
    prefix = "terraform/state"
  }
}