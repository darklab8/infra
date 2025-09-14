module "ssh_key" {
  source = "../modules/hetzner_ssh_key"
}

module "node_darklab_cax21" {
  source     = "../modules/hetzner_server"
  name       = "darklab"
  hardware   = "cax31"
  backups    = true
  ssh_key_id = module.ssh_key.id
  datacenter = "hel1-dc2"
}

provider "docker" {
  alias    = "darklab"
  host     = "ssh://darklab"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

resource "docker_network" "caddy" {
  provider   = docker.darklab
  name       = "caddy"
  attachable = true
  driver     = "overlay"
}

module "docker" {
  source = "../modules/docker_stack"
  providers = {
    docker = docker.darklab
  }
  zone             = "dd84ai.com"
  ipv4_address     = module.node_darklab_cax21.ipv4_address
  caddy_network_id = docker_network.caddy.id
}
