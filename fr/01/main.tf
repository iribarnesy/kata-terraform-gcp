terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project = "kata-terraform-gcp"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}
