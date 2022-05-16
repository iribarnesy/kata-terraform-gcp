
#                  _       _     _           
#                 (_)     | |   | |          
# __   ____ _ _ __ _  __ _| |__ | | ___  ___ 
# \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
#  \ V / (_| | |  | | (_| | |_) | |  __/\__ \
#   \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#                                            
locals {
  region       = "europe-west1"
  project_id   = "subtle-builder-348511"
  project_name = "terraformkata"
  username     = "ippon"
}

#                   __ _                       _   _             
#                  / _(_)                     | | (_)            
#   ___ ___  _ __ | |_ _  __ _ _   _ _ __ __ _| |_ _  ___  _ __  
#  / __/ _ \| '_ \|  _| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | (_| (_) | | | | | | | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         __/ |                                  
#                        |___/                                   
#
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

#  _           _                       
# (_)         | |                      
#  _ _ __  ___| |_ __ _ _ __   ___ ___ 
# | | '_ \/ __| __/ _` | '_ \ / __/ _ \
# | | | | \__ \ || (_| | | | | (_|  __/
# |_|_| |_|___/\__\__,_|_| |_|\___\___|
#                                      
resource "google_compute_instance" "vm_instance" {
  name                      = "${local.project_name}-${local.username}-instance"
  machine_type              = "e2-micro"
  allow_stopping_for_update = true

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
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo echo '${file("gif_display.html")}' > /var/www/html/index.html
                EOF
}

#             _                      _    
#            | |                    | |   
#  _ __   ___| |___      _____  _ __| | __
# | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ /
# | | | |  __/ |_ \ V  V / (_) | |  |   < 
# |_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\
#                                         
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

#                           _ _         
#                          (_) |        
#  ___  ___  ___ _   _ _ __ _| |_ _   _ 
# / __|/ _ \/ __| | | | '__| | __| | | |
# \__ \  __/ (__| |_| | |  | | |_| |_| |
# |___/\___|\___|\__,_|_|  |_|\__|\__, |
#                                  __/ |
#                                 |___/ 

# Allow HTTP(S) from everywhere
resource "google_compute_firewall" "everywhere_to_http" {
  name        = "${local.project_name}-${local.username}-ingress-allow-everywhere-to-http"
  network     = google_compute_network.vpc.name
  description = "Allow HTTP(S) from everywhere"

  direction = "INGRESS"
  priority  = 1000

  # Everywhere
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }
}
# Allow SSH connection
resource "google_compute_firewall" "iap_to_ssh" {
  name        = "${local.project_name}-${local.username}-ingress-allow-iap-to-ssh"
  network     = google_compute_network.vpc.name
  description = "Allow SSH from IAP sources"

  direction = "INGRESS"
  priority  = 1000

  # Cloud IAP's TCP forwarding netblock
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = [22]
  }
}

#              _               _       
#             | |             | |      
#   ___  _   _| |_ _ __  _   _| |_ ___ 
#  / _ \| | | | __| '_ \| | | | __/ __|
# | (_) | |_| | |_| |_) | |_| | |_\__ \
#  \___/ \__,_|\__| .__/ \__,_|\__|___/
#                 | |                  
#                 |_|                  
output "instance_public_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
output "instance_private_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}
output "instance_id" {
  value = google_compute_instance.vm_instance.id
}
