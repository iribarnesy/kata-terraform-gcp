terraform {
  required_providers {
    google = {
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "${var.region}-c"
}

resource "google_compute_instance" "vm_instance" {
  name                      = "terraformkata-ippon-instance-${count.index}"
  machine_type              = "e2-micro"
  allow_stopping_for_update = true
  count                     = var.instance_count

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
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link
  }
}

resource "google_compute_network" "vpc" {
  name                    = "terraformkata-ippon-vpc"
  project                 = var.project_id
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "terraformkata-ippon-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}


