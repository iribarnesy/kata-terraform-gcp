terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project = "subtle-builder-348511"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}
