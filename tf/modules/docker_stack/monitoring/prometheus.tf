resource "docker_image" "prometheus" {
  name         = "prom/prometheus:v3.2.1"
  keep_locally = true
}

locals {
  prometheus_envs = {
  }
}

locals {
  prometheus_config = file("${path.module}/prometheus.yaml")
}

resource "docker_volume" "prometheus_data" {
  name = "prometheus_data"
}

resource "docker_container" "prometheus" {
  count = var.metrics.enabled ? 1 : 0
  name  = "prometheus"

  image = docker_image.prometheus.name
  env   = [for k, v in local.prometheus_envs : "${k}=${v}"]

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["prometheus"]
  }

  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.prometheus_config}' > /etc/prometheus/prometheus.yml",
    join(" ", [
      "/bin/prometheus",
      "--config.file=/etc/prometheus/prometheus.yml",
      "--web.enable-remote-write-receiver",
      "--enable-feature=exemplar-storage",
      "--storage.tsdb.retention.time=30d",
      "--storage.tsdb.retention.size=10GB",
    ]),
  ])]
  restart = "always"

  mounts {
    target    = "/prometheus"
    source    = docker_volume.prometheus_data.name
    type      = "volume"
    read_only = false
  }

  # exposed port 9090

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}
