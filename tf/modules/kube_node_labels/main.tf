resource "kubernetes_labels" "node_stuff" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "cluster-arm64"
  }
  labels = {
    "node" = "arm"
  }
}