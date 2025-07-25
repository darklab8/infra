resource "docker_network" "network" {
  name       = "bastion"
  attachable = true
  driver     = "overlay"
}

data "docker_network" "grafana" {
  name = "grafana"
}

resource "docker_image" "openssh" {
  name = "linuxserver/openssh-server:version-9.9_p2-r0"
}

locals {
  key = file("~/.ssh/id_rsa.darklab.pub")
}

locals {
  ssh_config = file("${path.module}/ssh_config")
}

resource "docker_container" "openssh" {
  name    = "bastion"
  image   = docker_image.openssh.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.network.id
  }

  networks_advanced {
    name = data.docker_network.grafana.id
  }
  log_opts = {
    "max-file": "3"
    "max-size": "10m"
  }
  env = [
    "PUBLIC_KEY=${local.key}",
    "PUBLIC_KEY_URL=https://github.com/dd84ai.keys",
    "DOCKER_MODS=linuxserver/mods:openssh-server-ssh-tunnel",
  ]

  ports {
    internal = "2222"
    external = "2222"
  }

  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
    ]
  }
}