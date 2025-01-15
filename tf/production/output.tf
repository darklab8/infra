module "data_cluster" {
  source       = "./output/serializer"
  node_darklab = {
    ipv4_address = module.node_darklab.ipv4_address
    caddy_network_id = module.caddy.network_id
  }
}

output "data_cluster" {
  value     = module.data_cluster
  sensitive = true
}
