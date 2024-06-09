module "ssh_key" {
  source = "../modules/hetzner_ssh_key"
}

module "cluster" {
  source = "../modules/kube_cluster"
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
