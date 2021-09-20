
// HTTP Load Balancer 

resource "google_compute_health_check" "http_health_check" {
  name               = local.health_check_name
  project            = local.project_id
  check_interval_sec = local.hc_check_interval_sec
  timeout_sec        = local.hc_timeout_sec

  http_health_check {
    port         = local.hc_port
    request_path = local.hc_request_path
  }
}

resource "google_compute_backend_service" "backend_service" {
  name    = "" 
  # local.backend_service_name
  project = local.project_id

  health_checks = [
    google_compute_health_check.http_health_check.id
  ]

  backend {
    group = module.vm_mig.instance_group
  }

  log_config {
    enable      = true
    sample_rate = 1
  }
}

resource "google_compute_url_map" "urlmap" {
  name            = local.url_map_name
  project         = local.project_id
  default_service = google_compute_backend_service.backend_service.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = local.http_proxy_name
  project = local.project_id
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_global_address" "lb_ip_address" {
  name = local.lb_ip_address_name
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "mig-lb-http"
  project    = local.project_id
  ip_address = google_compute_global_address.lb_ip_address.address
  port_range = "80-80"
  target     = google_compute_target_http_proxy.http_proxy.id
}
