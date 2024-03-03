locals {
  node_name = "node-${var.name}"
}

module "server" {
  source       = "../hetzner_server"
  environment  = var.environment
  name         = local.node_name
  hardware     = var.server["hardware"]
  backups      = lookup(var.server, "backups", null)
  ssh_key_id   = var.ssh_id
  datacenter   = var.server["datacenter"]
}

module "microk8s" {
   source       = "../ansible_microk8s"
   hostname     = module.server.ipv4_address
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
  depends_on = [
    module.microk8s,
  ]
}

resource "kubernetes_storage_class" "storage" {
  metadata {
    name = "hostpath-retainer-${local.node_name}"
  }
  storage_provisioner = "microk8s.io/hostpath"
  reclaim_policy      = "Retain"
  parameters = {
    pvDir = "/var/lib/darklab"
  }
  volume_binding_mode = "WaitForFirstConsumer"
  allow_volume_expansion = true

  allowed_topologies {
    match_label_expressions {
      key = "node"
      values = [
        var.name,
      ]
    }
  }
}