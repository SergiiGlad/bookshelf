// VPC Network
resource "google_compute_network" "vpc_network" {
  project                 = local.project_id
  name                    = local.network_name
  description             = "New VPC network with custom subnet in ${local.region} region"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          = local.subnetwork_name
  project       = local.project_id
  ip_cidr_range = local.ip_cidr_range
  region        = local.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = local.network
}

resource "google_service_networking_connection" "servicepeering" {
  network                 = local.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

// Cloud NAT 
resource "google_compute_router" "router" {
  project = local.project_id
  name    = local.router_name
  network = local.network
  region  = local.region
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.0.0"
  project_id                         = local.project_id
  region                             = local.region
  router                             = google_compute_router.router.name
  name                               = local.cloud_nat_name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "default" {

  name          = "allow-to-http-server"
  source_ranges = ["0.0.0.0/0"]
  project       = local.project_id
  network       = local.network
  direction     = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }
  target_tags = local.tags
}

