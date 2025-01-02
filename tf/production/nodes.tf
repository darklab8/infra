# module "node_arm" {
#   source        = "../modules/kube_node"
#   environment   = "production"
#   ssh_id        = module.ssh_key.id
#   init_hostname = "cluster-arm64"
#   name          = "arm"
#   server = {
#     datacenter = "hel1-dc2"
#     hardware   = "cax31"
#     backups    = true
#   }
# }

module "node_darklab" {
  source        = "../modules/kube_node"
  environment   = "production"
  ssh_id        = module.ssh_key.id
  init_hostname = "cluster-darklab"
  name          = "darklab"
  server = {
    datacenter = "hel1-dc2"
    hardware   = "cax11"
    backups    = true
  }
}


module "data_cluster" {
  source       = "./output/serializer"
  node_darklab = module.node_darklab
}

output "data_cluster" {
  value     = module.data_cluster
  sensitive = true
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

