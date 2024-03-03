module "server" {
  source       = "../hetzner_server"
  environment  = "production"
  name         = "node-arm"
  server_power = "cax31"
  backups      = false
  ssh_key_id   = var.ssh_id
  datacenter   = "hel1-dc2"
}

module "microk8s" {
   source       = "../ansible_microk8s"
   hostname     = module.server.cluster_ip
}

resource "kubernetes_labels" "labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "cluster-arm64"
  }
  labels = {
    "node" = "arm"
  }
}