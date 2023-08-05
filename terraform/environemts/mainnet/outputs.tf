output "project_id" {
  description = "Id of the project"
  value       = module.main.project_id
}

output "gke_cluster_name" {
  description = "Cluster name"
  value       = module.main.gke_cluster_name
}

output "gke_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.main.gke_location
}

output "gke_region" {
  description = "Subnet/Router/Bastion Host region"
  value       = module.main.gke_region
}

output "gke_endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.main.gke_endpoint
}

output "gke_master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.main.gke_master_authorized_networks_config
}

output "gke_ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.main.gke_ca_certificate
}

output "gke_network_name" {
  value       = module.main.gke_network_name
  description = "The name of the VPC being created"
}

output "gke_subnet_name" {
  value       = module.main.gke_subnet_name
  description = "The name of the VPC subnet being created"
}

output "gke_router_name" {
  description = "Name of the router that was created"
  value       = module.main.gke_router_name
}

output "gke_cloud_nat_name" {
  description = "Name of the Cloud NAT that was created"
  value       = module.main.gke_cloud_nat_name
}

output "gke_get_credentials_command" {
  description = "gcloud get-credentials command to generate kubeconfig for the private cluster"
  value       = module.main.gke_get_credentials_command
}

output "gke_bastion_name" {
  description = "Name of the bastion host"
  value       = module.main.gke_bastion_name
}

output "gke_bastion_zone" {
  description = "Location of bastion host"
  value       = module.main.gke_bastion_zone
}

output "gke_bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = module.main.gke_bastion_ssh_command
}

output "gke_bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = module.main.gke_bastion_kubectl_command
}
