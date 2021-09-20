// Instance template (with initial startup-script) 
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "6.4.0"

  project_id   = local.project_id
  name_prefix  = local.name_prefix
  machine_type = local.machine_type
  tags         = local.tags
  region       = local.region

  # disk
  source_image_project = local.source_image_project
  source_image_family  = local.source_image_family
  disk_size_gb         = local.disk_size_gb
  disk_type            = local.disk_type
  disk_labels          = local.disk_labels
  auto_delete          = local.auto_delete

  # network
  network    = local.network
  subnetwork = local.subnetwork

  startup_script = local.startup_script

  # service_account
  service_account = local.instance_sa
}

// Managed Instance Group 
module "vm_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "6.4.0"

  project_id = local.project_id
  region     = local.region

  // google compute region autoscaler 
  autoscaler_name     = local.autoscaler_name
  autoscaling_enabled = local.autoscaling_enabled
  min_replicas        = local.min_replicas
  max_replicas        = local.max_replicas
  cooldown_period     = local.cooldown_period
  autoscaling_cpu     = local.autoscaling_cpu

  // google compute region instance group manager
  mig_name          = local.mig_name
  target_size       = local.mig_target_size
  hostname          = local.mig_prefix
  instance_template = local.instance_template
  health_check      = local.health_check
  named_ports       = local.named_ports
  mig_timeouts      = local.mig_timeouts
  depends_on = [
    module.bookshelf-mysql-db
  ]
}

// Service Account for Application instance 
resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = "Service Account for Application instance"
}

// IAM for service account
resource "google_project_iam_member" "project" {
  project = local.project_id
  role    = "roles/source.reader"
  member  = local.service_account
}

resource "google_project_iam_member" "logging" {
  project = local.project_id
  role    = "roles/logging.logWriter"
  member  = local.service_account
}

resource "google_project_iam_member" "monitoring" {
  project = local.project_id
  role    = "roles/monitoring.metricWriter"
  member  = local.service_account
}

resource "google_project_iam_member" "cloudsql" {
  project = local.project_id
  role    = "roles/cloudsql.editor"
  member  = local.service_account
}

resource "google_project_iam_member" "pubsub" {
  project = local.project_id
  role    = "roles/pubsub.editor"
  member  = local.service_account
}

resource "google_project_iam_member" "storage" {
  project = local.project_id
  role    = "roles/storage.objectAdmin"
  member  = local.service_account
}

