variable "context" {
  type = string
}

resource "null_resource" "app" {
  triggers = {
    build     = "${sha1(file("${path.module}/build/build.yaml"))}"
  }

  provisioner "local-exec" {
    command     = "kubectl apply --context ${var.context} -f ${path.module}/build"
    working_dir = path.module
  }
}
