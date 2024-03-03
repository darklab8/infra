data "hcloud_image" "default" {
  name = "docker-ce"
  with_architecture = "arm"
}

resource "hcloud_server" "cluster" {
  name        = var.name
  image       = data.hcloud_image.default.id
  datacenter  = var.datacenter
  server_type = var.hardware
  ssh_keys = [
    var.ssh_key_id,
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  lifecycle {
    ignore_changes = [
      image,
      ssh_keys, # for legacy servers
    ]
  }

  backups = var.backups == null ? false : var.backups
}

output "cluster_ip" {
  value = hcloud_server.cluster.ipv4_address
}

