variable "context" {
  type = string
}

variable "environment" {
  type = string
}

variable "repo_url" {
  type = string
}

variable "repo_path" {
  type = string
}

locals {
  file_content = <<EOT
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.environment}-discovery
  namespace: argocd
spec:
  project: default
  source:
    repoURL: ${var.repo_url}
    targetRevision: HEAD
    path: ${var.repo_path}
  destination:
    server: https://kubernetes.default.svc
    namespace: ${var.environment}
  syncPolicy:
    automated: {}
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${var.environment}
  labels:
    name: ${var.environment}
EOT
}

resource "local_file" "discovery" {
  content  = local.file_content
  filename = "gen-discovery.yaml"
}

resource "null_resource" "app" {
  triggers = {
    build     = local_file.discovery.content_md5
  }

  provisioner "local-exec" {
    command     = "kubectl apply --context ${var.context} -f gen-discovery.yaml"
  }

  depends_on = [
    local_file.discovery
  ]
}
