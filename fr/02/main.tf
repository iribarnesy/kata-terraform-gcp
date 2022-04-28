terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project     = //TODO add the id of your project
  region      = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = //TODO add your name 
  machine_type = "e2-medium"
  zone         = "899969920992"

  labels = {
    User= //TODO add your name 
    project="TerraformDemo"
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