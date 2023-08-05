project_id = "myriad-social-testnet"
service_accounts = [
  {
    name = "myriad-api",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "myriad-web-app",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "myriad-web-federated",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  }
]
gh_oidc_repository_owner = "myriadsocial"
gke_network_name         = "myriadsocial"
gke_subnet_name          = "myriadsocial-subnet"
gke_router_name          = "myriadsocial"
gke_cluster_name         = "myriadsocial"
gke_node_pools           = [
  {
    name         = "general"
    machine_type = "e2-standard-2"
    min_count    = 1
    max_count    = 2
    auto_upgrade = true
  }
]
