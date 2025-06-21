locals {
  loki_uid       = "loki-datasource"
  prometheus_uid = "prometheus-datasource"
  tempo_uid      = "tempo-datasource"
}

resource "grafana_data_source" "loki" {
  type               = "loki"
  name               = "Loki"
  uid                = local.loki_uid
  url                = "http://loki:3100"
  access_mode        = "proxy"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    timeout       = 60
    maxLines      = 5000
    tlsSkipVerify = true
    derivedFields = [{
      datasourceUid = local.tempo_uid
      matcherRegex  = "trace_id"
      name          = "trace_id"
      url : "$${__value.raw}"
      urlDisplayLabel : "trace_id"
      matcherType = "label"
    }]
  })
}

resource "grafana_data_source" "prometheus" {
  type               = "prometheus"
  name               = "Prometheus"
  uid                = local.prometheus_uid
  access_mode        = "proxy"
  url                = "http://prometheus:9090"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    httpMethod = "GET"
    exemplarTraceIdDestinations = [{
      datasourceUid = local.tempo_uid
      name          = "traceID"
    }]
  })
}

resource "grafana_data_source" "alertmanager" {
  type               = "alertmanager"
  name               = "Alertmanager"
  uid                = "P7647F508D5F54FCB"
  access_mode        = "proxy"
  url                = "http://localhost:9093"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    # Valid options for implementation include mimir, cortex and prometheus
    implementation = "prometheus"
    # Whether or not Grafana should send alert instances to this Alertmanager
    handleGrafanaManagedAlerts = true
  })

}

resource "grafana_data_source" "tempo" {
  type               = "tempo"
  name               = "Tempo"
  uid                = local.tempo_uid
  access_mode        = "proxy"
  url                = "http://tempo:3200"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    httpMethod = "GET"
    serviceMap = {
      datasourceUid = local.prometheus_uid
    }
    tracesToLogsV2 = {
      customQuery = false
      # Field with an internal link pointing to a logs data source in Grafana.
      # datasourceUid value must match the uid value of the logs data source.
      datasourceUid      = local.loki_uid
      spanStartTimeShift = "-1h"
      spanEndTimeShift   = "1h"
      # tags: ['job', 'instance', 'pod', 'namespace']
      filterByTraceID = true
    }
    tracesToMetrics = {
      datasourceUid = local.prometheus_uid
      # Example of configuring Traces to Metrics. Disabled because not super useful in comparison to proper dashboard
      # tags = [
      #   { key = "service.name", value = "service" },
      #   { key="span_name", value = "span_name"  }, # if u will add it to attributes, u will be able to filter by it
      # ]
      # queries = [
      #   {
      #     name = "Traces latency P90"
      #     query= "histogram_quantile(0.90, sum(rate(traces_spanmetrics_latency_bucket{$__tags}[5m])) by (le, span_name))"
      #   },
      #   {
      #     name = "Traces latency P50"
      #     query= "histogram_quantile(0.50, sum(rate(traces_spanmetrics_latency_bucket{$__tags}[5m])) by (le, span_name))"
      #   }
      # ]
    }
  })
}
