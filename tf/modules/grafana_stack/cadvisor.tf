module "folder_cadvisor" {
  source = "./grafana_folder"
  title  = "CADVISOR"
  uid    = "cadvisor"
}

locals {
  grafana-dashboards-cadvisor = {
    cadvisor_exporter_14282_rev1 = {
      json = file("${path.module}/cadvisor/cadvisor_exporter_14282_rev1.json")
    }
    db_19792_rev6 = {
      json = file("${path.module}/cadvisor/19792_rev6.json")
    }
    db_19908_rev1 = {
      json = file("${path.module}/cadvisor/cadvisor_insights_19908_rev1.json")
    }
  }
}

resource "grafana_dashboard" "cadvisor" {
  for_each    = local.grafana-dashboards-cadvisor
  folder      = module.folder_cadvisor.uid
  config_json = each.value.json
  depends_on = [
    module.folder_cadvisor.uid
  ]
}
