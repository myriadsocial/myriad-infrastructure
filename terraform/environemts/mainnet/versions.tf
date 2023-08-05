terraform {
  backend "gcs" {
    bucket  = "myriad-social-mainnet-data-terraform"
    prefix = "terraform/state"
  }

  required_version = ">= 1.2.8"
}

