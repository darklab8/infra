module "ssh_key" {
  source = "../modules/hetzner_ssh_key"
}

module "cluster" {
  source = "../modules/kube_cluster"
}

module "argo" {
  source  = "../../k8s/modules/argo_cue"
  context = "darklab"
}

module "discovery" {
  source      = "../modules/kube_argo_discovery"
  environment = "production"
  project     = "infra"
  repo_url    = "https://github.com/darklab8/infra.git"
  repo_path   = "k8s/production/build"
}
