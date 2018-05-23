provider "google" {
  credentials = "${file("../.secret/terraformer.json")}"
  project     = "upheld-garage-204720"
  region      = "us-west1"
}

resource "google_compute_network" "production" {
  name                    = "production"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "us-west1" {
  name          = "default-us-west1"
  ip_cidr_range = "10.0.0.0/16"
  network       = "${google_compute_network.production.self_link}"
  region        = "us-west1"
  secondary_ip_range {
    range_name = "pod-net"
    ip_cidr_range = "10.1.0.0/16"
  }
}

resource "google_compute_firewall" "production" {
  name    = "allow-all"
  network = "${google_compute_network.production.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "9090"]
  }

}

resource "google_container_cluster" "primary" {
  name               = "test-cluster"
  zone               = "us-west1-b"
  initial_node_count = 3
  network = "${google_compute_network.production.self_link}"
  subnetwork = "${google_compute_subnetwork.us-west1.self_link}"

  additional_zones = [
    "us-west1-a",
    "us-west1-c",
  ]

  private_cluster = "false"

  master_ipv4_cidr_block =  "10.2.0.0/28"

  master_auth {
    username = "austin"
    password = "2ab96390c7dbe3439de74d0c9b0b1767"
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "pod-net"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      foo = "bar"
    }

    tags = ["foo", "bar"]
  }
#  addons_config {
#    horizontal_pod_autoscaling {
#        disabled = false
#    }
#  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
