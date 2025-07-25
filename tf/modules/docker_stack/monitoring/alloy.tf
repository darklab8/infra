resource "docker_image" "alloy" {
  name         = "grafana/alloy:v1.8.3"
  keep_locally = true
}

locals {
  alloy_envs = {
  }
}

locals {
  alloy_logs_config = file("${path.module}/cfg.logs.alloy")
}

resource "docker_container" "alloy_logs" {
  count   = var.logging.enabled ? 1 : 0
  name    = "alloy-logs"
  image   = docker_image.alloy.name
  env     = [for k, v in local.alloy_envs : "${k}=${v}"]
  restart = "always"

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["alloy-logs"]
  }
  log_opts = {
    "max-file": "3"
    "max-size": "10m"
  }
  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.alloy_logs_config}' > /etc/alloy/config.alloy",
    "/bin/alloy run /etc/alloy/config.alloy --storage.path=/var/lib/alloy/data",
  ])]

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
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

locals {
  alloy_metrics_config = file("${path.module}/cfg.metrics.alloy")
}

resource "docker_container" "alloy_metrics" {
  count   = var.metrics.enabled ? 1 : 0
  name    = "alloy-metrics"
  image   = docker_image.alloy.name
  env     = [for k, v in local.alloy_envs : "${k}=${v}"]
  restart = "always"

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["alloy-metrics"]
  }
  log_opts = {
    "max-file": "3"
    "max-size": "10m"
  }
  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.alloy_metrics_config}' > /etc/alloy/config.alloy",
    "/bin/alloy run /etc/alloy/config.alloy --storage.path=/var/lib/alloy/data",
  ])]

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    host_path      = "/cgroup"
    container_path = "/cgroup"
    read_only      = true
  }
  volumes {
    # Node prometheus + cadvisor default seems to be
    container_path = "/rootfs"
    host_path      = "/"
    read_only      = true
  }
  volumes {
    # Only for node prometheus
    container_path = "/host/proc"
    host_path      = "/proc"
    read_only      = true
  }
  volumes {
    # Cadvisor defaults to /sys, node prometheus can be forced taking from /sys too
    container_path = "/sys"
    host_path      = "/sys"
    read_only      = true
  }
  volumes {
    # https://prometheus.io/docs/guides/cadvisor/
    # cadvisor requirement to be this way
    container_path = "/var/run"
    host_path      = "/var/run"
    read_only      = false
  }
  volumes {
    # smth from cadvisor
    container_path = "/dev/disk"
    host_path      = "/dev/disk"
    read_only      = true
  }

  volumes {
    # smth from cadvisor
    container_path = "/host/etc"
    host_path      = "/etc"
    read_only      = true
  }

  privileged = true

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}

locals {
  alloy_traces_config = file("${path.module}/cfg.traces.alloy")
}

resource "docker_container" "alloy_traces" {
  count   = var.tracing.enabled ? 1 : 0
  name    = "alloy-traces"
  image   = docker_image.alloy.name
  env     = [for k, v in local.alloy_envs : "${k}=${v}"]
  restart = "always"

  networks_advanced {
    name    = docker_network.grafana.id
    aliases = ["alloy-traces"]
  }
  log_opts = {
    "max-file": "3"
    "max-size": "10m"
  }
  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.alloy_traces_config}' > /etc/alloy/config.alloy",
    "/bin/alloy run /etc/alloy/config.alloy --storage.path=/var/lib/alloy/data",
  ])]

  # exposes 4318

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}
