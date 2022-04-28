terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project     = "subtle-builder-348511"
  region      = "us-central1"
  zone        = "us-central1-c"
}