module "ssh_key" {
  source = "../modules/hetzner_ssh_key"
}

module "cluster" {
  source = "../modules/kube_cluster"
}

module "argo" {
  source  = "../modules/kube_argo"
  context = "darklab"
}

module "discovery" {
  source      = "../modules/kube_argo_discovery"
  environment = "production"
  project     = "infra"
  repo_url    = "https://github.com/darklab8/infra.git"
  repo_path   = "k8s/production/build"
}
