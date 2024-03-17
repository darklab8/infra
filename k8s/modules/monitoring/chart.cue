package monitoring

chart: {
    apiVersion: "v2"
    name: "Sample"
    description: "A Helm chart for sample app"
    type: "application"
    version: "0.1.0"
    appVersion: "beta"
}

values: {
"loki-stack": {
  grafana: enabled: true
    
  prometheus:
    enabled: true
    alertmanager: persistentVolume: enabled: false
    server: persistentVolume: enabled: false
    pushgateway:

  loki: config: table_manager: {
    retention_deletes_enabled: true
    retention_period: "336h"
  }
        
}


}

requirements: {
    dependencies: [
        {
            name: "loki-stack"
            repository: "https://grafana.github.io/helm-charts"
            version: "2.10.1"
        }
    ]
}