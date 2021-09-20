// Apis
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "10.3.2"

  project_id = var.project_id

  activate_apis = [
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "storage.googleapis.com"
  ]
}




