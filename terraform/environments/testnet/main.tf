module "main" {
  source = "../../modules/core"

  project_id                 = var.project_id
  region                     = var.region
  zones                      = var.zones
  service_accounts           = var.service_accounts
  storage_buckets            = var.storage_buckets
  gh_oidc_repository_owner   = var.gh_oidc_repository_owner
  gke_network_name           = var.gke_network_name
  gke_subnet_name            = var.gke_subnet_name
  gke_subnet_ip              = var.gke_subnet_ip
  gke_ip_range_pods_name     = var.gke_ip_range_pods_name
  gke_ip_range_pods          = var.gke_ip_range_pods
  gke_ip_range_services_name = var.gke_ip_range_services_name
  gke_ip_range_services      = var.gke_ip_range_services
  gke_router_name            = var.gke_router_name
  gke_bastion                = var.gke_bastion
  gke_cluster_name           = var.gke_cluster_name
  gke_node_pools             = var.gke_node_pools
}
