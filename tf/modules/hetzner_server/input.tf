variable "hardware" {
  type = string
}

variable "backups" {
  type    = bool
  default = null
}

variable "name" {
  type = string
}

variable "ssh_key_id" {
  type = string
}

variable "datacenter" {
  # valid values
  #       + "nbg1-dc3",
  # + "hel1-dc2",
  # + "fsn1-dc14",
  # + "ash-dc1",
  # + "hil-dc1",
  type = string
}

variable "firewall_rules" {
  type = list(object({
    direction  = string
    protocol   = string
    port       = string
    source_ips = list(string)
  }))
  default = []
}