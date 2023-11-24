terraform {
  backend "gcs" {
    bucket  = "myriad-social-testnet-data-terraform"
    prefix = "terraform/state"
  }
}
