/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "gke" {
  source             = "terraform-google-modules/kubernetes-engine/google"
  version            = "~> 16.0"
  project_id         = var.project
  name               = "cluster-${var.zone}-1"
  region             = var.region
  zones              = [var.zone]
  initial_node_count = 4
  network            = "svpc01"
  subnetwork         = "subnet3-lwest"
  ip_range_pods      = "gke-pods-cidr"
  ip_range_services  = "gke-services-cidr"
  
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
      service_account           = "prod-lwest-workloads@c4o-prod-lwest.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 10
    },
  ]

}