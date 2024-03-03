terraform {
  required_providers {
    cloudflare = {
      source  = "hashicorp/kubernetes"
    }
    ansible = {
      source  = "ansible/ansible"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
    }
  }
}
