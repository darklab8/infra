data "hcloud_image" "default" {
  name = "docker-ce"
  with_architecture = "arm"
}

resource "hcloud_server" "cluster" {
  name        = var.name
  image       = data.hcloud_image.default.id
  datacenter  = var.datacenter
  server_type = var.server_power
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
    ]
  }

  backups = var.backups
}

output "cluster_ip" {
  value = hcloud_server.cluster.ipv4_address
}
