module "caddy" {
  source = "./caddy"
}

module "monitoring" {
  source                  = "./monitoring"
  docker_network_caddy_id = module.caddy.network_id
  zone                    = var.zone
  ipv4_address            = var.ipv4_address
}

module "bastion" {
  source = "./bastion"
}
