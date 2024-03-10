terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    ansible = {
      source = "ansible/ansible"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}
