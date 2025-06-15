variable "docker_network_caddy_id" {
  type = string
}

variable "grafana_domain" {
  type = string
}

variable "grafana_password" {
  type = string
}
variable "logging" {
  type = object({
    enabled = bool
  })
}
variable "tracing" {
  type = object({
    enabled = bool
  })
}
variable "metrics" {
  type = object({
    enabled = bool
  })
}
variable "alerts" {
  type = object({
    enabled             = bool
    discord_webhook_url = optional(string, "")
  })
}