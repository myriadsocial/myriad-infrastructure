terraform {
  backend "gcs" {
    bucket  = "myriad-social-testnet-data-terraform"
    prefix = "terraform/state"
  }

  required_version = ">= 1.2.8"
}

