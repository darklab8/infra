module "data_cluster" {
  source = "./output/serializer"
  node_darklab = {
    ipv4_address     = module.node_darklab_cax21.ipv4_address
    caddy_network_id = module.docker.caddy.network_id
  }
}

output "data_cluster" {
  value     = module.data_cluster
  sensitive = true
}
