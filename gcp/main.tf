provider "google" {
  credentials = var.service_account_key_file
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "main" {
  name                    = var.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = var.name
  network       = google_compute_network.main.self_link
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_instance" "instances" {
  count        = 3
  name         = "${var.name}-${count.index}"
  machine_type = "n1-standard-1"
  tags         = [var.name]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.main.self_link
    access_config {} # Required (even if empty) for instance to get a public IP
  }
}

resource "google_compute_firewall" "internal" {
  name        = "${var.name}-internal"
  network     = google_compute_network.main.self_link
  target_tags = [var.name]
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  source_tags = [var.name]
}

resource "google_compute_firewall" "http" {
  name        = "${var.name}-http"
  network     = google_compute_network.main.self_link
  target_tags = [var.name]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "ssh" {
  name        = "${var.name}-ssh"
  network     = google_compute_network.main.self_link
  target_tags = [var.name]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${var.localhost_ip}/32"]
}
