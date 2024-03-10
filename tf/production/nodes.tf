module "node_arm" {
   source = "../modules/kube_node"
   environment = "production"
   ssh_id = module.ssh_key.id
   init_hostname = "cluster-arm64"
   name = "arm"
   server = {
    datacenter = "hel1-dc2"
    hardware   = "cax31"
    backups    = true
   }
}

module "node_amd" {
   source = "../modules/kube_node"
   environment = "production"
   ssh_id = module.ssh_key.id
   init_hostname = "production-avorion"
   name = "amd"
   server = {
    datacenter = "ash-dc1"
    hardware   = "cpx31"
    backups    = true
   }
}

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
          image = "busybox"
          name  = "example"
          command = [ "tail", "-f", "/dev/null" ]


        }
      }
    }
  }
}

# resource "kubernetes_pod_v1" "test" {
#   count = var.mode == "kubernetes" ? 1 : 0
#   metadata {
#     name      = "darkbot"
#     namespace = local.namespace
#   }

#   spec {

#     }

#     restart_policy = "Always"
#     container {
#       image = local.image_name
#       name  = "app"

#       volume_mount {
#         name       = "volv"
#         mount_path = "/code/data"
#         read_only  = false
#       }

#       dynamic "env" {
#         for_each = local.envs
#         content {
#           name  = env.key
#           value = env.value
#         }
#       }
#     }
#     volume {
#       name = "volv"
#       host_path {
#         path = "/var/lib/darklab/darkbot-${var.environment}"
#         type = "DirectoryOrCreate"
#       }
#     }
#   }

#   lifecycle {
#     ignore_changes = [
#       metadata,
#     ]
#   }
# }
