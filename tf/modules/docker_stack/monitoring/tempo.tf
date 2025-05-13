resource "docker_image" "tempo" {
  name         = "grafana/tempo:2.7.2"
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
  name = "tempo_data"
}

resource "docker_container" "tempo" {
  name  = "tempo"
  image = docker_image.tempo.name
  env   = [for k, v in local.tempo_envs : "${k}=${v}"]
  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["tempo"]
  }
  user       = "root"
  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.tempo_config}' > /etc/tempo.yaml",
    join(" ", [
      "/tempo",
      "-config.file=/etc/tempo.yaml",
    ]),
  ])]
  restart = "always"
  log_opts = {
    "mode" : "non-blocking"
    "max-buffer-size" : "500m"
  }
  mounts {
    target    = "/var/tempo"
    source    = docker_volume.tempo_data.name
    type      = "volume"
    read_only = false
  }

  # exposed port 4318 and 4317

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}
