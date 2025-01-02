variable "node_darklab" {
  type = object({
    ipv4_address : string,
  })
}

output "node_darklab" {
  value = var.node_darklab
}

