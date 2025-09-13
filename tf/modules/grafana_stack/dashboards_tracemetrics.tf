locals {
  grafana-dashboards-tracemetrics = {
    db_tracemetrics = {
      json = file("${path.module}/tracemetrics/tracementrics.json")
    }
  }
}

resource "grafana_dashboard" "tracemetrics" {
  for_each    = local.grafana-dashboards-tracemetrics
  config_json = each.value.json
}
