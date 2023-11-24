project_id = "myriad-social-mainnet"
service_accounts = [
  {
    name = "myriad-api",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
      "roles/storage.admin",
      "roles/firebasenotifications.admin",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "myriad-web",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
  {
    name = "myriad-federated",
    roles = [
      "roles/iam.workloadIdentityUser",
      "roles/secretmanager.secretAccessor",
      "roles/secretmanager.viewer",
    ],
    gke_wif_enabled = true,
  },
]
gh_oidc_repository_owner = "myriadsocial"
gke_network_name         = "myriadsocial"
gke_subnet_name          = "myriadsocial-subnet"
gke_router_name          = "myriadsocial"
gke_cluster_name         = "myriadsocial"
gke_node_pools           = [
  {
    name         = "general"
    machine_type = "e2-medium"
    min_count    = 1
    max_count    = 1
    auto_upgrade = true
  }
]
