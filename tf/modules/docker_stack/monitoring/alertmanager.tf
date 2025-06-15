resource "docker_image" "alertmanager" {
  name         = "prom/alertmanager:v0.28.1"
  keep_locally = true
}

locals {
  alertmanager_envs = {
  }
}

locals {
  alertmanager_config = templatefile("${path.module}/alertmanager.yaml", {
    discord_webhook_url = var.alerts.discord_webhook_url
  })
}

resource "docker_volume" "alertmanager_data" {
  name = "alertmanager_data"
}

resource "docker_container" "alertmanager" {
  count = var.alerts.enabled ? 1 : 0
  name  = "alertmanager"

  image = docker_image.alertmanager.name
  env   = [for k, v in local.alertmanager_envs : "${k}=${v}"]

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["alertmanager"]
  }

  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.alertmanager_config}' > /etc/alertmanager/alertmanager.yml",
    "/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml",
  ])]
  restart = "always"

  mounts {
    target    = "/alertmanager"
    source    = docker_volume.alertmanager_data.name
    type      = "volume"
    read_only = false
  }

  # exposed port 9093

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}
