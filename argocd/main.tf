resource "kubernetes_namespace_v1" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  version    = var.argocd_helm_version
  timeout    = "1500"
  repository = var.argocd_helm_repository
  namespace  = kubernetes_namespace_v1.argocd_namespace.id
  values = [
    yamlencode({
      controller = {
        replicas = 1
      }
      server = {
        replicas = 1
        service = {
          type = "ClusterIP"
        }
        repoServer = {
          replicas = 1
        }
        applicationSet = {
          replicaCount = 1
        }
      }
      dex = {
        enabled = false
      }
      redis = {
        enabled = false
      }
    })
  ]
}

resource "null_resource" "password" {
  depends_on = [helm_release.argocd]
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
}

resource "null_resource" "del-argo-pass" {
  depends_on = [null_resource.password]
  provisioner "local-exec" {
    command = "kubectl -n argocd delete secret argocd-initial-admin-secret"
  }
}
