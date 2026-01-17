module "caddy" {
  source           = "./caddy"
  caddy_network_id = var.caddy_network_id
}

data "external" "secrets" {
  program = ["pass", "personal/terraform/grafana"]
}

module "monitoring" {
  source                  = "./monitoring"
  docker_network_caddy_id = module.caddy.network_id
  grafana_domain          = "grafana.dd84ai.com"
  grafana_password        = data.external.secrets.result["grafana_password"]

  logging = {
    enabled = true
  }
  tracing = {
    enabled = true
  }
  metrics = {
    enabled = true
  }
  alerts = {
    enabled             = true
    discord_webhook_url = data.external.secrets.result["discord_webhook_url"]
  }
}

module "dns" {
  source = "../cloudflare_dns"
  zone   = "dd84ai.com"
  dns_records = [{
    type  = "A"
    value = var.ipv4_address
    name  = "grafana"
  },
  {
    type  = "A"
    value = var.ipv4_address
    name  = "wiki"
  }]
}

module "bastion" {
  source = "./bastion"
}
