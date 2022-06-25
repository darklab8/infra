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


data "digitalocean_ssh_key" "pipeline" {
  name = "pet_project_pipeline"
}

data "digitalocean_ssh_key" "admin" {
  name = "dd84ai"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "darklab"
  region = "nyc1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.pipeline.id, data.digitalocean_ssh_key.admin.id]
  tags = ["terraform"]
}