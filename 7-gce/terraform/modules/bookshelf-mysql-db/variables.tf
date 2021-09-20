# Resource: Cloud SQL
variable "project_id" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "us-central1"
}

variable "cloud_redis_name" {
  type        = string
  default     = "ayo-web-cache"
  description = "(optional) describe your variable"
}

variable "name" {
  type        = string
  description = "The name of the Cloud SQL resources"
  default     = "bookshelf-test"
}

variable "vpc_id" {
  description = "Existing VPC network to which instances are connected. The networks needs to be configured with https://cloud.google.com/vpc/docs/configure-private-services-access."
  type        = string
  default     = "default"
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-n1-standard-1"
}

variable "database_version" {
  description = "The database version to use: SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, or SQLSERVER_2017_WEB"
  type        = string
  default     = "MYSQL_5_7"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance."
  default     = "a"
}

variable "availability_type" {
  description = "The availability type for the master instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = "ZONAL"
}

variable "disk_size" {
  description = "The disk size for the master instance."
  default     = 20
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_HDD"
}

variable "db_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "bookshelf"
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = "utf8"
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'utf8_general_ci'"
  type        = string
  default     = "utf8_general_ci"
}

variable "user_host" {
  description = "The host for the default user"
  type        = string
  default     = "%"
}

variable "sql_user" {
  description = "SQL user"
  type        = string
  default     = "root"
}

variable "additional_databases" {
  type        = list(string)
  default     = ["bookshelf"]
  description = "A list of additional databases to be created in your instance"
}

variable "additional_usernames" {
  type        = list(string)
  default     = []
  description = "A list of additional usernames to be created in your instance"
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = [{
    name  = "log_bin_trust_function_creators"
    value = "on"
  }]
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 7
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 8
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    binary_log_enabled = bool
    enabled            = bool
    start_time         = string
  })
  default = {
    binary_log_enabled = true
    enabled            = true
    start_time         = "20:00"
  }
}

variable "password" {
  type        = string
  description = "root password"
}





