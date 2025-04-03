resource "docker_image" "alloy" {
  name         = "grafana/alloy:v1.7.5"
  keep_locally = true
}

locals {
  alloy_envs = {
  }
}

locals {
  alloy_logs_config = file("${path.module}/cfg.logs.alloy")
  alloy_config      = join("\n", [local.alloy_logs_config])
}

resource "docker_container" "alloy" {
  name    = "alloy"
  image   = docker_image.alloy.name
  env     = [for k, v in local.alloy_envs : "${k}=${v}"]
  restart = "always"

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["alloy"]
  }

  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.alloy_config}' > /etc/alloy/config.alloy",
    "/bin/alloy run /etc/alloy/config.alloy --storage.path=/var/lib/alloy/data",
  ])]

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
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
