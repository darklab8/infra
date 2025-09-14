variable "alloy_network_id" {
  type = string
}
variable "bridge_network_id" {
  type = string
}
resource "docker_image" "docker_metrics" {
  name = "docker_metrics"
  build {
    context = path.module
  }

  triggers = {
    dir_sha1 = sha1(join("", [for f in ["Dockerfile", "main.go", "go.mod", "go.sum"] : filesha1("${path.module}/${f}")]))
  }
}

resource "docker_container" "docker_metrics" {
  name  = "docker-metrics"
  image = docker_image.docker_metrics.image_id
  networks_advanced {
    name    = var.alloy_network_id
    aliases = ["docker-metrics"]
  }
  networks_advanced { // useful to debug containers since it is curlable directly
    name = var.bridge_network_id
  }
  log_opts = {
    "max-file" : "3"
    "max-size" : "10m"
  }
  restart = "always"
  labels {
    label = "prometheus"
    value = "true"
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
    ]
  }
}
