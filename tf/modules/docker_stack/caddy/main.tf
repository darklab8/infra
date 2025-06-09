resource "docker_network" "network" {
  name       = "caddy"
  attachable = true
  driver     = "overlay"
}

resource "docker_image" "caddy" {
  name = "caddy_docker_proxy_grcp"
  build {
    context = path.module
  }

  triggers = {
    dir_sha1 = sha1(join("", [for f in ["Dockerfile", "Caddyfile"] : filesha1("${path.module}/${f}")]))
  }
}

resource "docker_container" "caddy" {
  name    = "caddy"
  image   = docker_image.caddy.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.network.id
  }
  log_opts = {
    "mode" : "non-blocking"
    "max-buffer-size" : "500m"
  }
  # Useful for rapid debugging. `docker stop caddy`, `docker start caddy`
  # env = [
  #   "CADDY_DOCKER_CADDYFILE_PATH=/config/Caddyfile"
  # ]
  # volumes {
  #   host_path      = "/var/lib/caddy"
  #   container_path = "/config"
  #   read_only      = false
  # }

  ports {
    internal = "80"
    external = "80"
  }
  ports {
    internal = "443"
    external = "443"
  }

  ports {
    internal = "888"
    external = "888"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    volume_name    = "caddy_data"
    container_path = "/data"
  }


  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
    ]
  }
}