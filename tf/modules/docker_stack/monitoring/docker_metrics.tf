module "docker_metrics" {
  source            = "./docker_metrics"
  alloy_network_id  = docker_network.grafana.id
  bridge_network_id = data.docker_network.bridge.id
}

data "docker_network" "bridge" {
  name = "bridge"
}
