# Configure the Hetzner Cloud Provider

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.35.2"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "3.26.0"
    }
  }

  backend "http" {
  }
}

locals {
  envornment = "ci"
  datacenter = "ash-dc1" # USA
  image = "ubuntu-20.04"
  server_type = "cpx11"
  task_name = "cluster"
}

resource "hcloud_ssh_key" "admin" {
  name       = "darklab_admin"
  public_key = file("../../ssh_darklab_admin.pub")
}

resource "hcloud_ssh_key" "pipeline" {
  name       = "darklab_pipeline"
  public_key = file("../../ssh_darklab_pipeline.pub")
}

resource "hcloud_server" "cluster" {
  name        = "${local.envornment}-cluster"
  image       = local.image
  datacenter    = local.datacenter
  server_type = local.server_type
  ssh_keys = [
    hcloud_ssh_key.admin.id,
    hcloud_ssh_key.pipeline.id,
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

locals {
  domain = "dd84ai.com"
  back_subdomain="dev"
}

data "cloudflare_zone" "domain_main" {
  name = local.domain
}

resource "cloudflare_record" "record_frontend" {
  ttl = 60
  type = "A"
  value = hcloud_server.cluster.ipv4_address
  name = "${local.envornment}-${local.task_name}.${local.domain}"
  zone_id = data.cloudflare_zone.domain_main.id
  proxied = false
}

