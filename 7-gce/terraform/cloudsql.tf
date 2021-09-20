// SQL instance with private IP address and SQL database 

module "bookshelf-mysql-db" {
  source = "./modules/bookshelf-mysql-db"

  project_id       = local.project_id
  name             = var.cloud_sql_name
  database_version = var.database_version
  db_name          = var.db_name

  // Location
  region   = local.region
  zone     = local.zone
  vpc_id   = local.network
  password = local.mysql_password
  depends_on = [
    google_service_networking_connection.servicepeering
  ]
}

