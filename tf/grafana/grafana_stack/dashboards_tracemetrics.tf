locals {
  grafana-dashboards-tracemetrics = {
    db_tracemetrics = {
      json = file("${path.module}/tracemetrics/tracementrics.json")
    }
  }
}

resource "grafana_dashboard" "tracemetrics" {
  for_each    = local.grafana-dashboards-tracemetrics
  folder      = module.folder_applications_public.uid
  config_json = each.value.json
}
