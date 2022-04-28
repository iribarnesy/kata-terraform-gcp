terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project     = // TODO add the id of your project
  region      = "us-central1"
}