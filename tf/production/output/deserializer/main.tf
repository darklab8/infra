data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "/home/naa/repos/pet_projects/darklab_secrets/encrypted/terraform/infra/production/terraform.tfstate"

  }
}

module "data_cluster" {
  source       = "../serializer"
  node_darklab = data.terraform_remote_state.cluster.outputs.data_cluster.node_darklab
}

output "node_darklab" {
  value = module.data_cluster.node_darklab
}
