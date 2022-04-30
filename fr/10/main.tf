
#                  _       _     _           
#                 (_)     | |   | |          
# __   ____ _ _ __ _  __ _| |__ | | ___  ___ 
# \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
#  \ V / (_| | |  | | (_| | |_) | |  __/\__ \
#   \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#                                            
locals {
  region = "europe-west1"
  project_id = "subtle-builder-348511"
  project_name = "terraformkata"
  username = "ippon"
}

terraform {
  required_providers {
    google = {
    }
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
  zone    = "${local.region}-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "${local.project_name}-${local.username}-instance"
  machine_type = "e2-micro"

  labels = {
    creator = local.username
    env     = "dev"
    project = local.project_name
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link
    access_config {
      nat_ip = "${google_compute_address.static_ip.address}"
  }
}

resource "google_compute_network" "vpc" {
  project                 = local.project_id
  name                    = "${local.project_name}-${local.username}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${local.project_name}-${local.username}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_address" "static_ip" {
  name = "${local.project_name}-${local.username}-static-ip"
}

