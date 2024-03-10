terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
    }
  }
}

resource "ansible_playbook" "playbook" {
  playbook   = "${path.module}/deploy.yml"
  name       = var.hostname
  replayable = false

  extra_vars = {
    ansible_user : "root"
    ansible_connection : "ssh"
    # ansible_ssh_extra_args: "-o ForwardAgent=yes"
    ansible_ssh_private_key_file : "~/.ssh/id_rsa.darklab"
  }
}

variable "hostname" {
  type = string
}