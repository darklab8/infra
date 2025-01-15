variable "node_darklab" {
  type = object({
    ipv4_address : string,
    caddy_network_id : string,
  })
}

output "node_darklab" {
  value = var.node_darklab
}

