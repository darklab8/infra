module "server" {
  source       = "../hetzner_server"
  environment  = var.environment
  name         = "node-${var.name}"
  hardware     = lookup(var.server, "hardware", null)
  backups      = false
  ssh_key_id   = var.ssh_id
  datacenter   = lookup(var.server, "datacenter", null)
}

module "microk8s" {
   source       = "../ansible_microk8s"
   hostname     = module.server.cluster_ip
}

resource "kubernetes_labels" "labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = var.init_hostname
  }
  labels = {
    "node" = var.name
  }
}