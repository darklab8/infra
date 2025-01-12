resource "docker_network" "network" {
  name       = "caddy"
  attachable = true
  driver     = "overlay"
}

resource "docker_image" "caddy" {
  name = "lucaslorentz/caddy-docker-proxy:2.9.1"
}

resource "docker_container" "caddy" {
  name    = "caddy"
  image   = docker_image.caddy.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.network.id
  }

  ports {
    internal = "80"
    external = "80"
  }
  ports {
    internal = "443"
    external = "443"
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