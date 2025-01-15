module "ssh_key" {
  source = "../modules/hetzner_ssh_key"
}

module "node_darklab" {
  source      = "../modules/hetzner_server"
  environment = "production"
  name        = "node-darklab"
  hardware    = "cax21"
  backups     = true
  ssh_key_id  = module.ssh_key.id
  datacenter  = "hel1-dc2"
}

provider "docker" {
  host     = "ssh://root@${module.node_darklab.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

module "caddy" {
  source = "../modules/caddy"
}
