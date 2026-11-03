resource "docker_image" "tempo" {
  name         = "docker.io/victoriametrics/victoria-traces:v0.9.4"
  keep_locally = true
}

locals {
  tempo_envs = {
  }
}

locals {
  tempo_config = file("${path.module}/tempo.yaml")
}

resource "docker_volume" "tempo_data" {
  name = "victoria_traces"
}

resource "docker_container" "tempo" {
  count = var.tracing.enabled ? 1 : 0
  name  = "victoria-traces"
  image = docker_image.tempo.name
  env   = [for k, v in local.tempo_envs : "${k}=${v}"]
  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["victoria-traces"]
  }

  command = [
    "-loggerFormat=json",
    "-retentionPeriod=1w",
    "-retention.maxDiskSpaceUsageBytes=5GiB"
  ]
  restart = "always"
  log_opts = {
    "max-file" : "3"
    "max-size" : "10m"
  }
  // may need chown -R 10001:10001 path_to_volume to function properly
  mounts {
    target    = "/victoria-traces-data"
    source    = docker_volume.tempo_data.name
    type      = "volume"
    read_only = false
  }

  # exposed port 10428

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
    ]
  }
}
