variable "environment" {
  type = string
}

variable "repo_url" {
  type = string
}

variable "repo_path" {
  type = string
}

variable "project" {
  type = string
}

resource "kubernetes_manifest" "autodiscovery" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "${var.environment}-${var.project}-discovery"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.repo_url
        targetRevision = "HEAD"
        path           = var.repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.environment
      }
    }
  }
}
