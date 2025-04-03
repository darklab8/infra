locals {
  dns = {
    grafana = {
      prefix = "grafana"
    }
  }
}

module "dns" {
  source = "../../cloudflare_dns"
  zone   = var.zone
  dns_records = [{
    type  = "A"
    value = var.ipv4_address
    name  = local.dns.grafana.prefix
  }]
}