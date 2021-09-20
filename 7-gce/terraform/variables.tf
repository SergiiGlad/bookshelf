variable "project_id" {
  type = string
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  default     = "frontend-group"
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "region" {
  default = "us-central1"
  type    = string
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = "debian-9"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  default     = "20"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "disk_labels" {
  description = "Labels to be assigned to boot disk, provided as a map"
  type        = map(string)
  default     = {}
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = "true"
}

variable "mig_target_size" {
  description = "The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  type        = number
  default     = 1
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  default     = "1"
}

variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = null
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "mig_prefix" {
  description = "Hostname prefix for instances"
  type        = string
  default     = "mig"
}

variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  default     = 8
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
  default     = 2
}

variable "lb_name" {
  type        = string
  description = "Load balance name"
  default     = "mig-lb-http"
}

variable "source_image_project" {
  type        = string
  description = "Project where the source image comes from."
  default     = "debian-cloud"
}

variable "network_name" {
  type        = string
  description = "The name or self_link of the network to attach this interface to."
  default     = "custom-network"
}

variable "subnetwork_name" {
  type        = string
  description = "The name or self_link of the subnetwork to attach this interface to."
  default     = "custom-subnetwork"
}

variable "router_name" {
  type        = string
  description = "Cloud router name"
  default     = "nat-router"
}

variable "cloud_nat_name" {
  type        = string
  description = "NAT config resource name"
  default     = "nat-config"
}

variable "cloud_sql_name" {
  type        = string
  description = "The name of the Cloud SQL resources"
  default     = "bookshelf1"
}

variable "database_version" {
  description = "The database version to use: SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, or SQLSERVER_2017_WEB"
  type        = string
  default     = "MYSQL_5_7"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance."
  default     = "f"
}

variable "db_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "bookshelf"
}

variable "ip_cidr_range" {
  default = "10.24.5.0/24"
  type    = string
}

variable "gcs_backend_name" {
  default = "gcs-images-store"
  type    = string
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "account_id" {
  description = "Service Account for Application instance"
  type        = string
  default     = "compute-sa"
}

variable "mysql_password_secret_id" {
  description = "Secret id to store mysql password"
  type        = string
  default     = "mysql_password"
}

variable "kms_name" {
  description = "Cloud KMS key-ring name"
  type        = string
  default     = "bookshelf-key"
}

variable "key_name" {
  description = "Cloud KMS key name"
  type        = string
  default     = "bookshelf-key"
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 300
}

variable "autoscaler_name" {
  type        = string
  description = "Autoscaler name. When variable is empty, name will be derived from var.hostname."
  default     = ""
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#cpu_utilization"
  type        = list(map(number))
  default = [{
    target = 0.80
  }]
}

variable "mig_name" {
  type        = string
  description = "Managed instance group name. When variable is empty, name will be derived from var.hostname."
  default     = ""
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    initial_delay_sec   = number
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request             = string
    request_path        = string
    host                = string
  })
  default = {
    type                = "http"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 8080
    request             = ""
    request_path        = "/_ah/health"
    host                = ""
  }
}

variable "health_check_name" {
  type        = string
  description = "Health check name. When variable is empty, name will be derived from var.hostname."
  default     = "mig-lb-http-hc-default"
}

variable "mig_timeouts" {
  description = "Times for creation, deleting and updating the MIG resources. Can be helpful when using wait_for_instances to allow a longer VM startup time. "
  type = object({
    create = string
    update = string
    delete = string
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "15m"
  }
}

variable "autoscaling_scale_in_control" {
  description = "Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#scale_in_control"
  type = object({
    fixed_replicas   = number
    percent_replicas = number
    time_window_sec  = number
  })
  default = {
    fixed_replicas   = null
    percent_replicas = 10
    time_window_sec  = 600
  }
}





