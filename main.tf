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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

provider "kind" {}

provider "kubectl" {
  config_path = kind_cluster.dev.kubeconfig_path
}


provider "helm" {
  kubernetes = {
    config_path = kind_cluster.dev.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path    = kind_cluster.dev.kubeconfig_path
  #config_context = var.cluster_name
}

resource "kind_cluster" "dev" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
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

module "argocd" {
  source = "./argocd"
  depends_on = [kind_cluster.dev]

  kubeconfig = kind_cluster.dev.kubeconfig
  kubecontext = var.cluster_name
}
