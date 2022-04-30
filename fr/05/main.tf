terraform {
  required_providers {
    google = {
    }
  }
}

provider "google" {
  project = "subtle-builder-348511"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "default" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  labels = {
    creator     = "ippon"
    environment = "dev"
    project     = "terraformdemo"
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

resource "google_compute_network" "vpc" {
  project                 = "subtle-builder-348511"
  name                    = "vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "vpc-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}


