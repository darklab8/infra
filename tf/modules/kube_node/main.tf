locals {
  node_name = "node-${var.name}"
}

module "server" {
  source      = "../hetzner_server"
  environment = var.environment
  name        = local.node_name
  hardware    = var.server["hardware"]
  backups     = lookup(var.server, "backups", null)
  ssh_key_id  = var.ssh_id
  datacenter  = var.server["datacenter"]
}

module "microk8s" {
  count    = var.install_microk8s ? 1 : 0
  source   = "../ansible_microk8s"
  hostname = module.server.ipv4_address
}

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
