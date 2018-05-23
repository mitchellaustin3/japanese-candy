variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default = "us-west1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-b (which must be in gcp_region)"
  default = "us-west1-b"
}

variable "gcp_project" {
  description = "name of project"
  default = "test-project"
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-2"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  default = "20"
}
