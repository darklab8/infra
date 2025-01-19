terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
    }
  }
}

variable "kube_version" {
  description = "Version of microk8s, for example 1.31" # IMPORTANT WITHOUT `v`
  type        = string
}

resource "ansible_playbook" "playbook" {
  playbook   = "${path.module}/deploy.yml"
  name       = var.hostname
  replayable = false
  verbosity  = 2

  extra_vars = {
    ansible_user : "root"
    ansible_connection : "ssh"
    # ansible_ssh_extra_args: "-o ForwardAgent=yes"
    ansible_ssh_private_key_file : "~/.ssh/id_rsa.darklab"
    kube_version = var.kube_version
  }
}

variable "hostname" {
  type = string
}