terraform {
  backend "gcs" {
    bucket  = "myriad-social-mainnet-data-terraform"
    prefix = "terraform/state"
  }
}
