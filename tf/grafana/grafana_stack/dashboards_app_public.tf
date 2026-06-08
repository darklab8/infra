module "folder_applications_public" {
  source    = "./grafana_folder"
  title     = "APPLICATIONS_PUBLIC"
  uid       = "applications_public"
  is_public = true
}

locals {
  grafana-app-dashboards = {
    darkbot = {
      json = file("${path.module}/dashboards_apps/darkbot.json")
    }
    darkstat_from_logs = {
      json = file("${path.module}/dashboards_apps/darkstat_from_logs.json")
    }
    darkstat = {
      json = file("${path.module}/dashboards_apps/darkstat.json")
    }
  }
}

resource "grafana_dashboard" "apps" {
  for_each    = local.grafana-app-dashboards
  folder      = module.folder_applications_public.uid
  config_json = jsonencode(merge(jsondecode(each.value.json), { "tags" = ["terraform"] }))
  depends_on = [
    module.folder_applications_public.uid
  ]
}
