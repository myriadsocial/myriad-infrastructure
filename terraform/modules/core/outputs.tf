output "project_id" {
  description = "Id of the project"
  value       = module.activate_apis.project_id
}

output "gke_cluster_name" {
  description = "Cluster name"
  value       = module.gke_cluster.name
}

output "gke_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke_cluster.location
}

output "gke_region" {
  description = "Subnet/Router/Bastion Host region"
  value       = module.gke_cluster.region
}

output "gke_endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke_cluster.endpoint
}

output "gke_master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.gke_cluster.master_authorized_networks_config
}

output "gke_ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke_cluster.ca_certificate
}

output "gke_network_name" {
  value       = module.gke_network.network_name
  description = "The name of the VPC being created"
}

output "gke_subnet_name" {
  value       = module.gke_network.subnets_names[0]
  description = "The name of the VPC subnet being created"
}

output "gke_router_name" {
  description = "Name of the router that was created"
  value       = module.gke_network.route_names
}

output "gke_cloud_nat_name" {
  description = "Name of the Cloud NAT that was created"
  value       = module.gke_cloud_nat.name
}

output "gke_get_credentials_command" {
  description = "gcloud get-credentials command to generate kubeconfig for the private cluster"
  value       = format("gcloud container clusters get-credentials --project %s --zone %s --internal-ip %s", module.activate_apis.project_id, module.gke_cluster.location, module.gke_cluster.name)
}

output "gke_bastion_name" {
  description = "Name of the bastion host"
  value       = module.gke_bastion.hostname
}

output "gke_bastion_zone" {
  description = "Location of bastion host"
  value       = var.zones[0]
}

output "gke_bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = format("gcloud compute ssh %s --tunnel-through-iap --project %s --zone %s -- -4 -L8888:127.0.0.1:8888 -N -q -f", module.gke_bastion.hostname, module.activate_apis.project_id, var.zones[0])
}

output "gke_bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = "HTTPS_PROXY=127.0.0.1:8888 kubectl get ns"
}
