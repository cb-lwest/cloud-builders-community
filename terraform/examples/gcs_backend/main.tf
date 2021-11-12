provider "google" {
  project     = "${var.project-name}"
  region      = "${var.region}"
}

// Create a new instance
resource "google_container_cluster" "terraform-builder-gcs-backend" {
  name               = "terraform-builder-gcs-backend"
  zone               = "${var.region}"
  initial_node_count = "3"

  node_config {
    disk_size_gb  = "10"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      reason = "terraform-builder-example"
    }

    tags = ["example"]
  }
}

module "gke" {
  source             = "terraform-google-modules/kubernetes-engine/google"
  version            = "~> 16.0"
  project_id         = var.project
  name               = "cluster-${var.zone}-1"
  region             = var.region
  zones              = [var.zone]
  initial_node_count = 4
  network            = "svpc01"
  subnetwork         = "subnet3-scongdon"
  ip_range_pods      = ""
  ip_range_services  = ""
}

node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-micro"
      node_locations            = "us-central1-b,us-central1-c"
      min_count                 = 1
      max_count                 = 100
      local_ssd_count           = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "prod-scongdon-workloads@c4o-prod-scongdon.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 80
    },
  ]