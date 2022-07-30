terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.21.0"
    }
  }

  backend "http" {
  }
}


variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "admin" {
  name = "admin"
}

data "digitalocean_ssh_key" "pipeline" {
  name = "pipeline_pet_project"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "darklab"
  region = "lon1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.pipeline.id, data.digitalocean_ssh_key.admin.id]
  tags = ["terraform"]
}