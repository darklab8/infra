module "node_arm" {
  source        = "../modules/kube_node"
  environment   = "production"
  ssh_id        = module.ssh_key.id
  init_hostname = "cluster-arm64"
  name          = "arm"
  server = {
    datacenter = "hel1-dc2"
    hardware   = "cax31"
    backups    = true
  }
}

# module "node_amd" {
#   source        = "../modules/kube_node"
#   environment   = "production"
#   ssh_id        = module.ssh_key.id
#   init_hostname = "production-avorion"
#   name          = "amd"
#   server = {
#     datacenter = "ash-dc1"
#     hardware   = "cpx31"
#     backups    = true
#   }
# }

