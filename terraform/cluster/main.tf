terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.32.2"
    }
  }

  backend "http" {
  }
}


# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Create a server
data "hcloud_ssh_key" "default" {
  name = "naa@shared2"
}

resource "hcloud_server" "darklab-cluster" {
  name        = "darklab-cluster"
  image       = "ubuntu-20.04"
  server_type = "cx41"
  location    = "hel1"
  ssh_keys    = [data.hcloud_ssh_key.default.id ]
  labels = {
      "terraform": "true"
  }
}