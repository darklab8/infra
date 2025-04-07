resource "docker_image" "grafana" {
  name         = "grafana/grafana:11.6.0@sha256:62d2b9d20a19714ebfe48d1bb405086081bc602aa053e28cf6d73c7537640dfb"
  platform     = "linux/arm64"
  keep_locally = true
}

data "external" "secrets" {
  program = ["pass", "personal/terraform/grafana"]
}

locals {
  # to add some day anon access?
  # GF_AUTH_ANONYMOUS_ENABLED=true
  # GF_AUTH_ANONYMOUS_ORG_ROLE=YourRole
  grafana_password = data.external.secrets.result["grafana_password"]
  grafana_envs = {
    GF_SECURITY_ADMIN_PASSWORD = local.grafana_password
    GF_SECURITY_ADMIN_USER     = "admin"
    GF_FEATURE_TOGGLES_ENABLE  = "alertingSimplifiedRouting,alertingQueryAndExpressionsStepMode"
  }
}

resource "docker_network" "grafana" {
  name       = "grafana"
  attachable = true
  driver     = "overlay"
}

locals {
  grafana_datasources_yaml = file("${path.module}/grafana-datasources.yaml")
}
# - name: Tempo
#   type: tempo
#   access: proxy
#   orgId: 1
#   url: http://tempo:3200
#   basicAuth: false
#   isDefault: false
#   version: 1
#   editable: true
#   apiVersion: 1
#   uid: tempo-datasource
#   jsonData:
#     httpMethod: GET
#     serviceMap:
#       datasourceUid: prometheus


resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}

resource "docker_container" "grafana" {
  name = "grafana"

  image = docker_image.grafana.name
  env   = [for k, v in local.grafana_envs : "${k}=${v}"]


  networks_advanced {
    name = docker_network.grafana.id
  }

  networks_advanced {
    name = var.docker_network_caddy_id
  }

  entrypoint = ["sh", "-c"]
  command = [join(" && ", [
    "echo '${local.grafana_datasources_yaml}' > /etc/grafana/provisioning/datasources/datasources.yaml",
    "/run.sh",
  ])]

  dynamic "labels" {
    for_each = merge({
      "caddy_0"               = "${local.dns.grafana.prefix}.${var.zone}"
      "caddy_0.reverse_proxy" = "{{upstreams 3000}}"
      },
    )
    content {
      label = labels.key
      value = labels.value
    }
  }

  mounts {
    target    = "/var/lib/grafana"
    source    = docker_volume.grafana_data.name
    type      = "volume"
    read_only = false
  }


  restart = "always"
  memory  = 1000 # MBs
  lifecycle {
    ignore_changes = [
      memory_swap,
      network_mode,
      image,
    ]
  }
}

