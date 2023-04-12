terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.30.0"
    }
  }
}

provider "linode" {
}

resource "linode_lke_cluster" "lke_cluster" {
    label       = "lke.everonline.eu"
    k8s_version = "1.25"
    region      = "eu-west"
    tags        = ["prod"]

    pool {
        type  = "g6-standard-1"
        count = 1

        autoscaler {
          min = 1
          max = 1
        }
    }

    pool {
        type  = "g6-standard-2"
        count = 1

        autoscaler {
          min = 1
          max = 1
        }
    }

  lifecycle {
    ignore_changes = [
      pool.0.count
    ]
  }
 
}