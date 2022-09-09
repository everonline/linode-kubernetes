terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
  }
}

provider "linode" {
}

resource "linode_lke_cluster" "lke_cluster" {
  label       = "lke.everonline.eu"
  k8s_version = "1.23"
  region      = "eu-west"

  pool {
    type  = "g6-standard-1"
    count = 1
  }
}