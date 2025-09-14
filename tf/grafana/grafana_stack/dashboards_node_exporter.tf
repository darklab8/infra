module "folder_node_exporter" {
  source    = "./grafana_folder"
  title     = "NODE_EXPORTER"
  uid       = "node_exporter"
  is_public = true
}

locals {
  grafana-dashboards-node_exporter = {
    db_1860_rev37_json = {
      json = file("${path.module}/node_exporter/1860_rev37.json")
    }
  }
}

resource "grafana_dashboard" "node_exporter" {
  for_each    = local.grafana-dashboards-node_exporter
  folder      = module.folder_node_exporter.uid
  config_json = each.value.json
  depends_on = [
    module.folder_node_exporter.uid
  ]
}
