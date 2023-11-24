terraform {
  required_version = ">= 1.2.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.5.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }
}
