module "ssh_key" {
   source       = "../modules/hetzner_ssh_key"
}

module "cluster" {
  source       = "../modules/hetzner_server"
  environment  = "production"
  name         = "node-arm"
  server_power = "cax31"
  backups      = false
  ssh_key_id   = module.ssh_key.id
  datacenter   = "hel1-dc2"
}

module "node_arm" {
   source       = "../modules/ansible_microk8s"
}

module "labels" {
   source       = "../modules/kube_node_labels"
}

output "cluster_ip" {
  value = module.cluster.cluster_ip
}

data "aws_ssm_parameter" "hetzner" {
  name = "/terraform/hetzner/darkbot/production"
}

locals {
  secrets = nonsensitive(jsondecode(data.aws_ssm_parameter.hetzner.value))
}

provider "docker" {
  host     = "ssh://root@${module.stack.cluster_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/id_rsa.darklab"]
}

