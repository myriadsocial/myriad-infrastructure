variable "project_id" {
  description = "Id of the project"
  type        = string
  default     = "my-project"
}

variable "region" {
  description = "The region to applied to the project"
  type        = string
  default     = "asia-southeast1"
}

variable "zones" {
  description = "List of zone to applied to the project"
  type        = list(string)
  default     = ["asia-southeast1-b"]
}

variable "service_accounts" {
  description = "The List of service accounts being created to the project"
  type = list(object({
    name            = string
    gke_wif_enabled = bool
    roles           = list(string)
  }))
  default = []
}

variable "storage_buckets" {
  description = "The list of storage buckets being activated to the project"
  type        = list(string)
  default     = []
}

variable "gh_oidc_repository_owner" {
  description = "GitHub Repository Owner"
  type        = string
  default     = "repo-owner"
}

variable "gke_network_name" {
  description = "The name of the network being created to host the cluster in"
  type        = string
  default     = "my-network"
}

variable "gke_subnet_name" {
  description = "The name of the subnet being created to host the cluster in"
  type        = string
  default     = "my-subnet"
}

variable "gke_subnet_ip" {
  description = "The cidr range of the subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "gke_ip_range_pods_name" {
  description = "The name of the ip range pods being created to host the cluster in"
  type        = string
  default     = "ip-range-pods"
}

variable "gke_ip_range_pods" {
  description = "The secondary cidr range to use for pods"
  type        = string
  default     = "10.20.0.0/18"
}

variable "gke_ip_range_services_name" {
  description = "The name of the ip range services being created to host the cluster in"
  type        = string
  default     = "ip-range-services"
}

variable "gke_ip_range_services" {
  description = "The secondary cidr range to use for services"
  type        = string
  default     = "10.30.0.0/18"
}

variable "gke_router_name" {
  description = "The name of the router being created to host the cluster in"
  type        = string
  default     = "my-router"
}

variable "gke_bastion" {
  description = "Bastion configuration"
  type = object({
    machine_type = string
    disk_size_gb = number
    members      = list(string)
  })
  default = {
    machine_type = "e2-micro"
    disk_size_gb = 10
    members      = []
  }
}

variable "gke_cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "my-cluster"
}

variable "gke_node_pools" {
  description = "List of node pool to host the cluster in"
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    auto_upgrade = bool
  }))
  default = [
    {
      name         = "general"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 4
      auto_upgrade = true
    }
  ]
}
