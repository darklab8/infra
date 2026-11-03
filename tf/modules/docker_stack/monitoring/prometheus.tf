
resource "docker_image" "victoria_metrics" {
  name         = "victoriametrics/victoria-metrics:v1.148.0"
  keep_locally = true
}

locals {
  victoria_metrics_envs = {}
}

resource "docker_volume" "victoria_metrics" {
  name = "victoria_metrics"
}

resource "docker_container" "victoria_metrics" {
  count = var.metrics.enabled ? 1 : 0
  name  = "victoria-metrics"

  image = docker_image.victoria_metrics.name
  env   = [for k, v in local.victoria_metrics_envs : "${k}=${v}"]

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["victoria-metrics"]
  }

  command = [
    "--selfScrapeInterval=30s",
    "-storageDataPath=victoria-metrics-data",
    "-retentionPeriod=300d",
  ]
  restart = "always"
  mounts {
    target    = "/victoria-metrics-data"
    source    = docker_volume.victoria_metrics.name
    type      = "volume"
    read_only = false
  }

  # exposed port 8428

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
    ]
  }
}
