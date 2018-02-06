variable "changeme" {
  default = 1
}

provider "google" {}

module "testing" {
  source = "github.com/matti/terraform-google-kubernetes-engine"

  settings = {
    region_name            = "europe-west1"
    zone_amount            = 1
    cluster_name           = "tf-state-repro"
    gke_min_master_version = "1.8.6-gke.0"
  }
}

# ------------ nodepool
locals {
  node_pool_common_settings = {
    cluster_name = "${module.testing.cluster_name}"
    cluster_zone = "${module.testing.cluster_zone}"

    machine_type = "n1-highcpu-4"
  }

  node_pool_default_settings = {
    name       = "default"
    node_count = "${var.changeme}"
  }

  node_pool_scaling_settings = {
    name = "scaling"

    autoscaling_min_node_count = 0
    autoscaling_max_node_count = 3
  }
}

module "testing_node_pool" {
  source = "github.com/matti/terraform-google-kubernetes-node-pool"

  settings = "${merge(local.node_pool_common_settings, local.node_pool_default_settings)}"
}

module "testing_node_pool_autoscale" {
  source = "github.com/matti/terraform-google-kubernetes-node-pool"

  settings = "${merge(local.node_pool_common_settings, local.node_pool_scaling_settings)}"
}
