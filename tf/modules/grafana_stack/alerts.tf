locals {
  alert_interval_seconds   = 60
  alert_disable_provenance = true
  alert_org_id             = "1"
}

resource "grafana_contact_point" "discord" {
  name = "discord"
  discord {
    url                     = var.discord_webhook_url
    disable_resolve_message = false
  }
}

resource "grafana_contact_point" "discord_pings" {
  name = "discord_pings"
  discord {
    url                     = var.discord_webhook_url
    disable_resolve_message = false
    message                 = "<@&1358601766794690580>, pinging alert" # role for "alerts"
  }
}


resource "grafana_notification_policy" "default" {
  group_by = [
    # A list of alert labels to group alerts into notifications by.
    # Use the special label "..." to group alerts by all labels, effectively disabling grouping.
  ]

  contact_point = grafana_contact_point.discord.name

  group_wait      = "10s" # "45s" #  10s
  group_interval  = "30s" # "5m"  # 30s?
  repeat_interval = "3h"  # "3h"  # 1h?

  disable_provenance = true
  policy {
    contact_point = grafana_contact_point.discord.name
    continue      = false
    group_by      = []
    mute_timings  = []

    matcher {
      label = "ping_channel"
      match = "!="
      value = "true"
    }
  }
  policy {
    contact_point = grafana_contact_point.discord_pings.name
    continue      = false
    group_by      = []
    mute_timings  = []

    matcher {
      label = "ping_channel"
      match = "="
      value = "true"
    }
  }
}

# to be aware about
# # https://github.com/grafana/terraform-provider-grafana/issues/870

resource "grafana_folder" "alerts_generic" {
  title = "Alerts"
}

resource "grafana_rule_group" "alerts_nodes0" {
  name               = "alert_node_high_disk_usage"
  folder_uid         = grafana_folder.alerts_generic.uid
  interval_seconds   = local.alert_interval_seconds
  disable_provenance = local.alert_disable_provenance
  org_id             = local.alert_org_id

  rule {
    annotations = {
      "summary"     = "instance {{ index $labels \"instance\" }} disk usage is already {{ index $values \"A\" }}%"
      "description" = "Description"
    }
    condition      = "node_disk_usage_threshold"
    exec_err_state = "Error"
    for            = "0s"
    is_paused      = false
    labels = {
      "ping_channel" = "true"
    }
    name          = "Instance disk usage > 70%"
    no_data_state = "NoData"
    data {
      datasource_uid = "prometheus-datasource"
      model = jsonencode(
        {
          editorMode   = "code"
          expr         = "max(100 - ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes)) by (instance)"
          instant      = true
          legendFormat = "__auto"
          range        = false
          refId        = "node_disk_usage"
        }
      )
      ref_id = "node_disk_usage"

      relative_time_range {
        from = 600
        to   = 0
      }
    }
    data {
      datasource_uid = "__expr__"
      model = jsonencode(
        {
          conditions = [
            {
              evaluator = {
                params = []
                type   = "gt"
              }
              operator = {
                type = "and"
              }
              query = {
                params = [
                  "node_disk_usage_last",
                ]
              }
              reducer = {
                params = []
                type   = "last"
              }
              type = "query"
            },
          ]
          datasource = {
            type = "__expr__"
            uid  = "__expr__"
          }
          expression = "node_disk_usage"
          reducer    = "last"
          refId      = "node_disk_usage_last"
          type       = "reduce"
        }
      )
      ref_id = "node_disk_usage_last"

      relative_time_range {
        from = 600
        to   = 0
      }
    }
    data {
      datasource_uid = "__expr__"
      model = jsonencode(
        {
          conditions = [
            {
              evaluator = {
                params = [
                  70,
                ]
                type = "gt"
              }
              operator = {
                type = "and"
              }
              query = {
                params = [
                  "node_disk_usage_threshold",
                ]
              }
              reducer = {
                params = []
                type   = "last"
              }
              type = "query"
            },
          ]
          datasource = {
            type = "__expr__"
            uid  = "__expr__"
          }
          expression = "node_disk_usage_last"
          refId      = "node_disk_usage_threshold"
          type       = "threshold"
        }
      )
      ref_id = "node_disk_usage_threshold"

      relative_time_range {
        from = 600
        to   = 0
      }
    }
  }
}

resource "grafana_rule_group" "rule_group_15cad967beae7328" {
  org_id             = 1
  name               = "darkbot_uptime_health"
  folder_uid         = "fei55y3yi1340d"
  interval_seconds   = 60
  disable_provenance = local.alert_disable_provenance


  rule {
    name      = "darkbot uptime health"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "prometheus-datasource"
      model          = "{\"disableTextWrap\":false,\"editorMode\":\"builder\",\"expr\":\"sum by(environment) (darkbot_uptime_seconds)\",\"fullMetaSearch\":false,\"includeNullMetadata\":true,\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\",\"useBackend\":false}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[60],\"type\":\"lt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "2m"
    labels = {
      ping_channel = "true"
    }
    is_paused = false
  }
}
