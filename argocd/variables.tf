variable "argocd_helm_repository" {
  description = "Argo CD Helm repository"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_helm_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "9.1.6"
}

