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
  name         = "terraformkata-ippon-instance"
  machine_type = "e2-micro"

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
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link
  }
}

resource "google_compute_network" "vpc" {
  project                 = "subtle-builder-348511"
  name                    = "terraformkata-ippon-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "terraformkata-ippon-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc.id
}


