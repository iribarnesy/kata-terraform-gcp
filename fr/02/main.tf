terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project     = "subtle-builder-348511"
  region      = "us-central1"
  zone = "us-central1-c"
}

resource "google_compute_instance" "default" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  labels = {
    creator = "ippon"
    environment = "dev" 
    project = "terraformdemo"
  }  

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}