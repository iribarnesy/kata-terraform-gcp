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
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }
}

resource "google_compute_network" "vpc" {
  project                 = "kata-terraform-gcp"
  name                    = "terraformkata-ippon-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "terraformkata-ippon-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc.id
}


