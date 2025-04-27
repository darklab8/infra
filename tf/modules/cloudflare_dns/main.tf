variable "zone" {
  type = string
}

data "cloudflare_zone" "domain_main" {
  filter = {
    name = var.zone
  }
}

variable "dns_records" {
  description = "cloudflare domain records"
  type = list(object({
    type    = string
    value   = string
    name    = string
    proxied = optional(bool, false)
  }))
}

resource "cloudflare_dns_record" "record" {
  for_each = {
    for index, record in var.dns_records : record.name => record
  }

  ttl     = each.value.proxied ? 1 : 60
  type    = each.value.type
  content = each.value.value
  name    = "${each.value.name}.${var.zone}"
  zone_id = data.cloudflare_zone.domain_main.zone_id
  proxied = each.value.proxied

  # settings = {
  #   ipv4_only = true
  #   ipv6_only = true
  # }
}
