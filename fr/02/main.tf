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

resource "google_compute_instance" "vm_instance" {
  name                      = "terraformkata-ippon-instance"
  machine_type              = "e2-micro"
  allow_stopping_for_update = true

  labels = {
    creator = "ippon"
    env     = "dev"
    project = "terraformkata"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}
