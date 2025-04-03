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
# - name: Prometheus
#   type: prometheus
#   uid: prometheus-datasource
#   access: proxy
#   orgId: 1
#   url: http://prometheus:9090
#   basicAuth: false
#   isDefault: true
#   version: 1
#   editable: true
#   jsonData:
#     httpMethod: GET
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


resource "docker_service" "grafana" {
  name = "grafana"

  task_spec {
    networks_advanced {
      name = docker_network.grafana.id
    }
    networks_advanced {
      name = var.docker_network_caddy_id
    }

    container_spec {
      image = docker_image.grafana.name
      env   = local.grafana_envs

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

      command = ["sh", "-c"]
      args = [join(" && ", [
        "echo '${local.grafana_datasources_yaml}' > /etc/grafana/provisioning/datasources/datasources.yaml",
        "/run.sh",
      ])]
    }
    restart_policy {
      condition = "any"
      delay     = "20s"
    }
    resources {
      limits {
        memory_bytes = 1000 * 1000 * 1000 # 1 gb
      }
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].restart_policy[0].window,
      task_spec[0].container_spec[0].image,
    ]
  }
}

