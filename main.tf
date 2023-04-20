terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }    
  }
}

provider "linode" {
}

resource "linode_lke_cluster" "lke_cluster" {
  label       = "lke.everonline.eu"
  k8s_version = "1.25"
  region      = "eu-west"
  tags        = ["linode"]

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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "metrics_server" {
    name = "metrics-server"

    repository       = "https://charts.bitnami.com/bitnami"
    chart            = "metrics-server"
    namespace        = "metrics-server"
    version          = "6.2.17"
    create_namespace = true

    set {
        name  = "apiService.create"
        value = "true"
    }

    set {
        name  = "args"
        value = "{--kubelet-insecure-tls=true}"
    }

    set {
        name  = "args"
        value = "{--kubelet-preferred-address-types=InternalIP}"
    }   

}