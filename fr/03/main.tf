terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project     = "my-project-id"
  region      = "us-east-1-b"
}