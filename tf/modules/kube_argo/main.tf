# difficult to put into terraform in a normal way. difficult.

variable context {
    type = string
}

resource "null_resource" "argo" {
  triggers = {
    namespace = "${sha1(file("${path.module}/namespace.yaml"))}"
    kustomization = "${sha1(file("${path.module}/kustomization.yaml"))}"
  }

  provisioner "local-exec" {
    command = "task argo:download && kubectl apply --context ${var.context} -k ."
    working_dir = path.module
  }
}
