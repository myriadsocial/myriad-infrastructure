module "activate_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = ">= 13.1.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false
  activate_apis               = [
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",

    "autoscaling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerfilesystem.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "multiclustermetering.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",

    "iap.googleapis.com",
    "oslogin.googleapis.com",
    "storage-api.googleapis.com",

    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = ">= 4.1.1"

  for_each = { for k, v in var.service_accounts : k => v }

  project_id    = var.project_id
  names         = [each.value.name]
  project_roles = [for role in each.value.roles : "${var.project_id}=>${role}"]

  depends_on = [
    module.activate_apis
  ]
}

module "storage_buckets" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = ">= 3.3.0"

  for_each = { for k, v in var.storage_buckets : k => v }

  project_id = var.project_id
  name       = "${var.project_id}-${each.value}"
  location   = upper(var.region)

  depends_on = [
    module.activate_apis
  ]
}

module "gh_oidc_service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = ">= 4.1.1"

  project_id    = var.project_id
  names         = ["github-actions"]
  project_roles = [
    "${var.project_id}=>roles/iam.serviceAccountUser",
    "${var.project_id}=>roles/iam.workloadIdentityUser",
    "${var.project_id}=>roles/iap.tunnelResourceAccessor",
    "${var.project_id}=>roles/compute.instanceAdmin.v1",
    "${var.project_id}=>roles/compute.osLogin",
    "${var.project_id}=>roles/container.clusterViewer",
    "${var.project_id}=>roles/container.developer",
  ]

  depends_on = [
    module.activate_apis
  ]
}

module "gh_oidc" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = ">= 3.1.0"

  project_id  = var.project_id
  pool_id     = "github-actions"
  provider_id = "oidc"
  sa_mapping = {
    "github-actions" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${module.gh_oidc_service_accounts.email}"
      attribute = "attribute.repository_owner/${var.gh_oidc_repository_owner}"
    }
  }
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  depends_on = [
    module.gh_oidc_service_accounts
  ]
}

module "gke_network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 5.2.0"

  project_id   = var.project_id
  network_name = var.gke_network_name
  routing_mode = "REGIONAL"
  mtu          = 1460
  subnets = [
    {
      subnet_name           = var.gke_subnet_name
      subnet_ip             = var.gke_subnet_ip
      subnet_region         = var.region
      subnet_private_access = true
    }
  ]
  secondary_ranges = {
    (var.gke_subnet_name) = [
      {
        range_name    = var.gke_ip_range_pods_name
        ip_cidr_range = var.gke_ip_range_pods
      },
      {
        range_name    = var.gke_ip_range_services_name
        ip_cidr_range = var.gke_ip_range_services
      },
    ]
  }

  depends_on = [
    module.activate_apis
  ]
}

module "gke_cloud_nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = ">= 2.2.1"

  project_id    = var.project_id
  region        = var.region
  network       = module.gke_network.network_self_link
  create_router = true
  router        = var.gke_router_name

  depends_on = [
    module.gke_network
  ]
}

module "gke_bastion_service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = ">= 4.1.1"

  project_id    = var.project_id
  names         = ["bastion"]
  project_roles = [
    "${var.project_id}=>roles/iam.serviceAccountUser",
    "${var.project_id}=>roles/compute.osLogin",
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
    "${var.project_id}=>roles/monitoring.viewer",
  ]

  depends_on = [
    module.activate_apis
  ]
}

module "gke_bastion_custom_roles" {
  source = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = ">= 7.4.1"

  target_id            = var.project_id
  role_id              = "bastionOSLoginProjectGet"
  title                = "Bastion OS Login Project Get Role"
  description          = "From Terraform: iap-bastion module custom role for more fine grained scoping of permissions"
  permissions          = ["compute.projects.get"]
  members              = ["serviceAccount:bastion@${var.project_id}.iam.gserviceaccount.com"]

  depends_on = [
    module.gke_bastion_service_accounts
  ]
}

data "template_file" "bastion_startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "gke_bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = ">= 5.0.0"

  project        = var.project_id
  host_project   = var.project_id
  name_prefix    = "bastion"
  name           = "bastion"
  zone           = var.zones[0]
  machine_type   = var.gke_bastion.machine_type
  disk_size_gb   = var.gke_bastion.disk_size_gb
  startup_script = data.template_file.bastion_startup_script.rendered
  network        = module.gke_network.network_self_link
  subnet         = module.gke_network.subnets_self_links[0]
  service_account_email = "bastion@${var.project_id}.iam.gserviceaccount.com"
  members        = concat(["serviceAccount:github-actions@${var.project_id}.iam.gserviceaccount.com"], var.gke_bastion.members)

  depends_on = [
    module.gke_cloud_nat,
    module.gke_bastion_service_accounts
  ]
}

module "gke_cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster-update-variant"
  version = ">= 23.0.0"

  project_id            = var.project_id
  name                  = var.gke_cluster_name
  region                = var.region
  zones                 = var.zones
  network               = module.gke_network.network_name
  subnetwork            = module.gke_network.subnets_names[0]
  ip_range_pods         = module.gke_network.subnets_secondary_ranges[0].*.range_name[0]
  ip_range_services     = module.gke_network.subnets_secondary_ranges[0].*.range_name[1]
  add_cluster_firewall_rules = true
  firewall_inbound_ports = [ 8443 ]
  initial_node_count    = 1
  node_pools            = var.gke_node_pools

  master_authorized_networks = [
    {
      cidr_block   = "${module.gke_bastion.ip_address}/32"
      display_name = "Bastion Host"
    }
  ]

  depends_on = [
    module.gke_bastion
  ]
}

module "gke_workload_identity_bindings" {
  source = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = ">= 7.4.1"

  for_each = { for k, v in var.service_accounts : k => v if v.gke_wif_enabled }

  project          = var.project_id
  service_accounts = ["${each.value.name}@${var.project_id}.iam.gserviceaccount.com"]
  bindings = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${var.project_id}.svc.id.goog[default/${each.value.name}]",
    ]
  }

  depends_on = [
    module.gke_cluster
  ]
}

module "redis" {
  source  = "terraform-google-modules/memorystore/google"
  version = ">= 5.1.0"

  project                 = var.project_id
  name                    = var.gke_cluster_name
  region                  = var.region
  location_id             = var.zones[0]
  enable_apis             = true
  auth_enabled            = true
  tier                    = "BASIC"
  transit_encryption_mode = null
  authorized_network      = module.gke_network.network_self_link
  memory_size_gb          = 1

  depends_on = [
    module.gke_cloud_nat
  ]
}
