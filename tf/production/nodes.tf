module "node_arm" {
   source = "../modules/kube_node"
   ssh_id = module.ssh_key.id
}
