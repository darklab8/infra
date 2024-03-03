resource "kubernetes_storage_class" "example" {
  metadata {
    name = "hostpath-retainer"
  }
  storage_provisioner = "microk8s.io/hostpath"
  reclaim_policy      = "Retain"
  parameters = {
    pvDir = "/var/lib/darklab"
  }
  volume_binding_mode = "WaitForFirstConsumer"
  allow_volume_expansion = true
}
