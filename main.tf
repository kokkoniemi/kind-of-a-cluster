terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.10.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}

provider "kind" {}
provider "kubectl" {
  config_path = kind_cluster.dev.kubeconfig_path
}

resource "kind_cluster" "dev" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    
    node {
      role = "control-plane"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
   }
}

