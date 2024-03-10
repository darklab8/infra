resource "kubernetes_deployment" "amd_scarecrow" {
  # only special apps like avorion are allowed there.
  metadata {
    name = "amd-scarecrow-deploy"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "amd-screwcrow-pod"
      }
    }

    template {
      metadata {
        labels = {
          app = "amd-screwcrow-pod"
        }
      }

      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node"
                  operator = "In"
                  values   = ["amd"]
                }
              }
            }
          }
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "node"
                  operator = "In"
                  values   = ["amd"]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        container {
          image   = "busybox"
          name    = "example"
          command = ["tail", "-f", "/dev/null"]


        }
      }
    }
  }
}
