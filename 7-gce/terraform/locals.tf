locals {
  project_id                = var.project_id
  name_prefix               = var.name_prefix
  tags                      = ["http-server"]
  region                    = var.region
  zone                      = "${var.region}-${var.zone}"
  network_name              = var.network_name
  subnetwork_name           = var.subnetwork_name
  network                   = google_compute_network.vpc_network.id
  subnetwork                = google_compute_subnetwork.subnet.id
  source_image_project      = var.source_image_project
  source_image_family       = var.source_image_family
  gcs_backend_name          = var.gcs_backend_name
  ip_cidr_range             = var.ip_cidr_range
  disk_size_gb              = var.disk_size_gb
  disk_type                 = var.disk_type
  disk_labels               = var.disk_labels != {} ? var.disk_labels : { disk : "boot" }
  auto_delete               = var.auto_delete
  machine_type              = var.machine_type
  router_name               = var.router_name
  cloud_nat_name            = var.cloud_nat_name
  key_name                  = "${local.project_id}/global/${var.kms_name}/${var.key_name}"
  mysql_password            = data.google_kms_secret.kms_secret.plaintext
  mysql_password_ciphertext = "CiQAzXk4UDbOY/8tjLb8KW2b3cR6yA5mjhnRopxLD6DcBjvjddISMgDXuGZ+fDWC0cWd4Hd+8lcumRsU6j1qFuS+Bi84sYW/V/Q0gP1mNWgFJnNbrDobG+X6"
  service_account           = "serviceAccount:${google_service_account.service_account.email}"
  instance_sa = {
    email  = google_service_account.service_account.email
    scopes = ["userinfo-email", "cloud-platform"]
  }
  startup_script = file("./startup-script.sh")
  named_ports = [
    {
      name = "http"
      port = "8080"
    }
  ]
  auto_healing_policies        = []
  instance_template            = module.instance_template.self_link
  mig_name                     = var.mig_name
  mig_target_size              = var.mig_target_size
  mig_prefix                   = var.mig_prefix
  min_replicas                 = var.min_replicas
  max_replicas                 = var.max_replicas
  autoscaling_scale_in_control = var.autoscaling_scale_in_control
  autoscaling_enabled          = true
  cooldown_period              = var.cooldown_period
  autoscaler_name              = var.autoscaler_name
  autoscaling_cpu              = var.autoscaling_cpu
  mig_timeouts                 = var.mig_timeouts
  lb_name                      = var.lb_name
  hc_check_interval_sec        = 60
  health_check_name            = var.health_check_name
  hc_timeout_sec               = 30
  hc_port                      = "8080"
  hc_request_path              = "/_ah/health"
  backend_service_name         = "mig-lb-http-backend"
  url_map_name                 = "mig-lb-http-url-map"
  http_proxy_name              = "mig-lb-http-proxy"
  lb_ip_address_name           = "lb-ip-address-bookshelf"
  health_check                 = var.health_check
}