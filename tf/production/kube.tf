module "microk8s" {
  source       = "../modules/ansible_microk8s"
  hostname     = module.node_darklab.ipv4_address
  kube_version = "1.31"
}

# module "argo" {
#   source  = "github.com/darklab8/argocd-cue.git?ref=v0.4.0-a3"
#   context = "darklab"
#   depends_on = [
#     module.cluster,
#   ]
# }

# module "discovery" {
#   source      = "../modules/kube_argo_discovery"
#   environment = "production"
#   project     = "infra"
#   repo_url    = "https://github.com/darklab8/infra.git"
#   repo_path   = "k8s/production"
#   depends_on = [
#     module.argo,
#   ]
# }

# resource "kubernetes_labels" "labels" {
#   api_version = "v1"
#   kind        = "Node"
#   metadata {
#     name = var.init_hostname
#   }
#   labels = {
#     "node" = var.name
#   }
#   depends_on = [
#     module.microk8s,
#   ]
# }
