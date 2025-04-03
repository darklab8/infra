module "ssh_key" {
  source = "../modules/hetzner_ssh_key"
}

module "node_darklab_cax21" {
  source      = "../modules/hetzner_server"
  environment = "production"
  name        = "darklab"
  hardware    = "cax21"
  backups     = true
  ssh_key_id  = module.ssh_key.id
  datacenter  = "hel1-dc2"
}

provider "docker" {
  alias    = "darklab"
  host     = "ssh://root@${module.node_darklab_cax21.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

module "docker" {
  source = "../modules/docker_stack"
  providers = {
    docker = docker.darklab
  }
  zone         = "dd84ai.com"
  ipv4_address = module.node_darklab_cax21.ipv4_address
}
