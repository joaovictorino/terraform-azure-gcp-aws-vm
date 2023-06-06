provider "google" {
  project = "teste-sample-388301"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_project_service" "cloud_resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "vpc-sample" {
  name = "vpc-sample"
}

resource "google_compute_address" "ip-sample" {
  name = "ip-sample"
}

resource "google_compute_firewall" "firewall-sample" {
  name          = "firewall-sample"
  network       = google_compute_network.vpc-sample.name
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "vm-sample" {
  name         = "vm-sample"
  machine_type = "f1-micro"

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc-sample.name

    access_config {
      nat_ip = google_compute_address.ip-sample.address
    }
  }

  tags = ["allow-ssh"]
}

output "public_ip_gcp" {
  value = google_compute_address.ip-sample.address
}