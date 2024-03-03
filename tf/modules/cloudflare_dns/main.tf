variable "zone" {
  type = string
}

data "cloudflare_zone" "domain_main" {
  name = var.zone
}

variable "dns_records" {
  description = "cloudflare domain records"
  type = list(object({
    type    = string
    value   = string
    name    = string
    proxied = bool
  }))
}

resource "cloudflare_record" "record" {
  for_each = {
    for index, record in var.dns_records : record.name => record
  }

  ttl     = 60
  type    = each.value.type
  value   = each.value.value
  name    = each.value.name
  zone_id = data.cloudflare_zone.domain_main.id
  proxied = each.value.proxied
}
