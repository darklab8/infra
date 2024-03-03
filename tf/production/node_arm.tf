module "node_arm_server" {
  source       = "../modules/hetzner_server"
  environment  = "production"
  name         = "node-arm"
  server_power = "cax31"
  backups      = false
  ssh_key_id   = module.ssh_key.id
  datacenter   = "hel1-dc2"
}

module "node_arm_microk8s" {
   source       = "../modules/ansible_microk8s"
   hostname     = module.node_arm_server.cluster_ip
}

provider "docker" {
  alias    = "node_arm"
  host     = "ssh://root@${module.node_arm_server.cluster_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

