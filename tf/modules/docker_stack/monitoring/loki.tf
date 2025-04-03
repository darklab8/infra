resource "docker_image" "loki" {
  name         = "grafana/loki:3.4.2"
  keep_locally = true
}

locals {
  loki_envs = {
  }
}

locals {
  loki_config = file("${path.module}/loki-local-config.yaml")
}

resource "docker_volume" "loki_data" {
  name = "loki_data"
}

resource "docker_container" "loki" {
  name = "loki"

  image = docker_image.loki.name
  env   = [for k, v in local.loki_envs : "${k}=${v}"]

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["loki"]
  }

  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.loki_config}' > /etc/loki/local-config.yaml",
    "/usr/bin/loki -config.file=/etc/loki/local-config.yaml",
  ])]
  restart = "always"

  mounts {
    target    = "/data"
    source    = docker_volume.loki_data.name
    type      = "volume"
    read_only = false
  }

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}
