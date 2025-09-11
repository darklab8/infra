resource "hcloud_firewall" "basic_firewall" {
  name = "firewall-${var.name}"

  // ping
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # docker swarm stuff
  # rule {
  #   direction = "in"
  #   protocol  = "tcp"
  #   port      = "2377"
  #   source_ips = [
  #     "0.0.0.0/0",
  #     "::/0"
  #   ]
  # }
  # rule {
  #   direction = "in"
  #   protocol  = "udp"
  #   port      = "2377"
  #   source_ips = [
  #     "0.0.0.0/0",
  #     "::/0"
  #   ]
  # }
  # rule {
  #   direction = "in"
  #   protocol  = "tcp"
  #   port      = "7946"
  #   source_ips = [
  #     "0.0.0.0/0",
  #     "::/0"
  #   ]
  # }
  # rule {
  #   direction = "in"
  #   protocol  = "udp"
  #   port      = "7946"
  #   source_ips = [
  #     "0.0.0.0/0",
  #     "::/0"
  #   ]
  # }
  # rule {
  #   direction = "in"
  #   protocol  = "tcp"
  #   port      = "4789"
  #   source_ips = [
  #     "0.0.0.0/0",
  #     "::/0"
  #   ]
  # }
  # rule {
  #   direction = "in"
  #   protocol  = "udp"
  #   port      = "4789"
  #   source_ips = [
  #     "0.0.0.0/0",
  #     "::/0"
  #   ]
  # }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "2222"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  dynamic "rule" {
    for_each = var.firewall_rules
    content {
      direction  = rule.value["direction"]
      protocol   = rule.value["protocol"]
      port       = rule.value["port"]
      source_ips = rule.value["source_ips"]
    }
  }
}

resource "hcloud_firewall_attachment" "fw_ref" {
  firewall_id = hcloud_firewall.basic_firewall.id
  server_ids  = [hcloud_server.cluster.id]
}