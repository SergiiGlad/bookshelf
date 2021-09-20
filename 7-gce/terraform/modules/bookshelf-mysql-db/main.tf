resource "google_sql_database_instance" "mysql" {

  project             = var.project_id
  name                = var.name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = false

  settings {

    availability_type = var.availability_type
    ip_configuration {
      ipv4_enabled    = false
      require_ssl     = false
      private_network = var.vpc_id
    }

    // Machine type and storage
    disk_type       = var.disk_type
    disk_size       = var.disk_size
    disk_autoresize = var.disk_autoresize
    tier            = var.tier

    location_preference {
      zone = var.zone
    }
  }
}

resource "google_sql_database" "db" {
  name      = var.db_name
  project   = var.project_id
  instance  = google_sql_database_instance.mysql.name
  charset   = var.db_charset
  collation = var.db_collation
}

resource "google_sql_user" "users" {
  name     = var.sql_user
  instance = google_sql_database_instance.mysql.name
  password = var.password
  host     = "%"
}