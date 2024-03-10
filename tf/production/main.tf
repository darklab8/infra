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
