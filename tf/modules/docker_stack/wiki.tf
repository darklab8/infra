resource "docker_image" "wiki" {
  name         = "leomoonstudios/wiki-go:1.8"
  keep_locally = true
}

resource "docker_volume" "wiki_data" {
  name = "wiki_data"
}

resource "docker_container" "wiki" {
  name  = "wiki"

  image = docker_image.wiki.name

  networks_advanced {
    name    = module.caddy.network_id
    aliases = ["wiki"]
  }

  restart = "always"

  mounts {
    target    = "/wiki/data"
    source    = docker_volume.wiki_data.name
    type      = "volume"
    read_only = false
  }

  dynamic "labels" {
    for_each = merge({
      "caddy_0"               = "wiki.dd84ai.com"
      "caddy_0.reverse_proxy" = "{{upstreams 8080}}"
      },
    )
    content {
      label = labels.key
      value = labels.value
    }
  }

  # exposed port 8080

  memory = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}
